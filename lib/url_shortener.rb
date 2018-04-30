# frozen_string_literal: true

class UrlShortener
  def initialize(store_client); end

  def shorten(_payload)
    # shorten business
    # store
    # return
    {
      original_url: 'http://blonk',
      shortened_url: 'http://ac3e34',
      slug: false,
      written: true
    }
  end

  def resolve(payload)
    # lookup
    # return
  end
end
