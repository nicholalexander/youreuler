# frozen_string_literal: true

class UrlShortener
  class Error
    # Error when key does not exist in redis
    class InvalidPayload < UrlShortener::Error
      def initialize
        @status_code = 400
        super
      end

      def message
        'Payload invalid.  Make sure you specify original_url key or parameter.'
      end
    end
  end
end
