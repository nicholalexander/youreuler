# frozen_string_literal: true

class UrlTransformer
  class Error
    # Error when key does not exist in redis
    class InvalidSlug < UrlTransformer::Error
      def initialize
        super
        @status_code = 400
      end

      def message
        'Slug invalid.  "api" is restricted from being in the path - sorry.'
      end
    end
  end
end
