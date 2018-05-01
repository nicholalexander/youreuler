# frozen_string_literal: true

class UrlShortener
  CHARACTER_SPACE = ('a'..'z').to_a +
                    ('A'..'Z').to_a +
                    (0..9).to_a.map{|number| number.to_s}

  CHARACTER_SPACE_SIZE = CHARACTER_SPACE.size

  def initialize(base_url, redis)
    @base_url = base_url
    @redis = redis
  end

  def shorten(payload)
    short_url = generate_short_url(payload['slug'])
    short_code = URI.parse(short_url).path[1..-1]
    # TODO: must check if key is unique!

    {
      original_url: payload['original_url'],
      short_url: short_url,
      short_code: short_code
    }
  end

  private

  def generate_short_url(slug)
    short_url = @base_url
    short_url += format_slug(slug) if slug
    short_url + generate_code
  end

  def generate_code
    (0..5).map { CHARACTER_SPACE[rand(CHARACTER_SPACE_SIZE)] }.join
  end

  def format_slug(slug)
    slug.delete('/')
    "#{slug}/"
  end
end
