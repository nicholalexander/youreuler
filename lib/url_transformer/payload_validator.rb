# frozen_string_literal: true

class UrlTransformer
  # Validate user provided payload
  class PayloadValidator
    def self.call(payload)
      check_original_url_present(payload)
      check_original_url_valid(payload['original_url'])
      check_slug(payload['slug']) if payload['slug']
    end

    class << self
      private

      def check_original_url_present(payload)
        raise UrlTransformer::Error::InvalidPayload unless
          payload.keys.include? 'original_url'
      end

      def check_slug(slug)
        raise UrlTransformer::Error::InvalidSlug if slug =~ /api/
      end

      def check_original_url_valid(url)
        raise UrlTransformer::Error::InvalidUrl unless url_is_valid?(url)
      end

      def url_is_valid?(url)
        url =~ url_matcher
      end

      def url_matcher
        # credit to http://urlregex.com/
        %r{\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})
          (?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})
          (?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])
          (?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])
          (?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}
          (?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|
          (?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)
          (?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*
          (?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z
        }x
      end
    end
  end
end
