# frozen_string_literal: true

class UrlTransformer
  class Error
    # Error when key does not exist in redis
    class InvalidUrl < UrlTransformer::Error
      def initialize
        super
        @status_code = 400
      end

      def message
        'Url invalid.  Make sure you specify a good url.'
      end
    end
  end
end
