# frozen_string_literal: true

class UrlShortener
  CHARACTER_SPACE = ('a'..'z').to_a +
                    ('A'..'Z').to_a +
                    (0..9).to_a

  CHARACTER_SPACE_SIZE = CHARACTER_SPACE.size

  def initialize(storage_client, base_url)
    @storage_client = storage_client
    @base_url = base_url
  end

  def shorten(payload)
    original_url = payload['original_url']
    slug = payload['slug']
    short_url = generate_short_url(slug)

    # store_client.write response
    {
      original_url: original_url,
      short_url: short_url,
      slug: slug
    }
  end

  def resolve(payload)
    # lookup
    # return
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
