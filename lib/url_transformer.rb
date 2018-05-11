# frozen_string_literal: true

require_relative './url_transformer/error'
require_relative './url_transformer/error/resolve_key'
require_relative './url_transformer/error/invalid_payload'
require_relative './url_transformer/error/invalid_slug'
require_relative './url_transformer/payload_validator'
require_relative './url_transformer/shortener'

# UrlTransformer is responsible for shortening urls and writing them to
# the redis store.  It is also able to resolve short links to their
# full url.
class UrlTransformer
  CHARACTER_SPACE = ('a'..'z').to_a +
                    ('A'..'Z').to_a +
                    (0..9).to_a.map(&:to_s)

  CHARACTER_SPACE_SIZE = CHARACTER_SPACE.size

  LONG_CODE_LENGTH = 256

  REDIS_RETRIES = 5

  def initialize(base_url, redis)
    @base_url = base_url
    @redis = redis
  end

  def shorten(payload)
    UrlTransformer::Shortener.new(@base_url, @redis).transform(payload)
  end


  # def enlengthen(payload)
  #   original_url = payload['original_url']

  #   long_code = generate_unique_long_code(payload['slug'])
  #   long_url = build_url(long_code)
    
  #   write_to_redis(long_code, original_url)
  #   build_response(original_url, long_url, long_code)
  # end

  def resolve(key)
    key = @redis.get(key)
    raise UrlTransformer::Error::ResolveKey unless key
    key
  end

  private

  def write_to_redis(short_code, original_url)
    @redis.setnx(short_code, original_url)
    # raise error if response is not OK
  end

  def generate_unique_code(slug)
    begin
      retries ||= 0
      key = slug ? format_slug(slug) + generate_code : generate_code
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

  def generate_long_code
    (0..LONG_CODE_LENGTH).map { CHARACTER_SPACE[rand(CHARACTER_SPACE_SIZE)] }.join
  end

  def build_url(short_code)
    @base_url + short_code
  end
end
