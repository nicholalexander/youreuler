# frozen_string_literal: true

class UrlTransformer
  class Error
    # Error when key does not exist in redis
    class InvalidPayload < UrlTransformer::Error
      def initialize
        super
        @status_code = 400
      end

      def message
        'Payload invalid.  Make sure you specify original_url key or parameter.'
      end
    end
  end
end
