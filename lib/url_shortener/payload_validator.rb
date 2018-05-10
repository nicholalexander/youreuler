# frozen_string_literal: true

class UrlShortener
  # Validate user provided payload
  class PayloadValidator
    def self.call(payload)
      check_original_url(payload)
      check_slug(payload['slug']) if payload['slug']
    end

    class << self
      private

      def check_original_url(payload)
        raise UrlShortener::Error::InvalidPayload unless
          payload.keys.include? 'original_url'
      end

      def check_slug(slug)
        raise UrlShortener::Error::InvalidSlug if slug =~ /api/
      end
    end
  end
end
