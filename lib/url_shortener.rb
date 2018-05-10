# frozen_string_literal: true

require_relative './url_shortener/payload_validator'
require_relative './url_shortener/error'
require_relative './url_shortener/error/resolve_key'
require_relative './url_shortener/error/invalid_payload'

# UrlShortener is responsible for shortening urls and writing them to
# the redis store.  It is also able to resolve short links to their
# full url.
class UrlShortener
  CHARACTER_SPACE = ('a'..'z').to_a +
                    ('A'..'Z').to_a +
                    (0..9).to_a.map(&:to_s)

  CHARACTER_SPACE_SIZE = CHARACTER_SPACE.size

  CODE_LENGTH = 5

  REDIS_RETRIES = 5

  def initialize(base_url, redis)
    @base_url = base_url
    @redis = redis
  end

  def validate_payload(payload)
    UrlShortener::PayloadValidator.call(payload)
    true
  end

  def shorten(payload)
    original_url = payload['original_url']

    short_code = generate_unique_short_code(payload['slug'])
    short_url = build_url(short_code)

    write_to_redis(short_code, original_url)
    build_response(original_url, short_url, short_code)
  end

  def resolve(key)
    key = @redis.get(key)
    raise UrlShortener::Error::ResolveKey unless key
    key
  end

  private

  def build_response(original_url, short_url, short_code)
    {
      original_url: original_url,
      short_url: short_url,
      short_code: short_code
    }
  end

  def write_to_redis(short_code, original_url)
    @redis.setnx(short_code, original_url)
    # raise error if response is not OK
  end

  def generate_unique_short_code(slug)
    begin
      retries ||= 0
      key = slug ? format_slug(slug) + generate_short_code : generate_short_code
      raise 'Key Exists' if @redis.exists(key)
    rescue StandardError => error
      raise error if error.message != 'Key Exists'
      retry if (retries += 1) < REDIS_RETRIES
      raise 'Redis Keyspace Is Too Crowded!'
    end

    key
  end

  def format_slug(slug)
    slug = slug.delete('/')
    "#{slug}/"
  end

  def generate_short_code
    (0..CODE_LENGTH).map { CHARACTER_SPACE[rand(CHARACTER_SPACE_SIZE)] }.join
  end

  def build_url(short_code)
    @base_url + short_code
  end
end
