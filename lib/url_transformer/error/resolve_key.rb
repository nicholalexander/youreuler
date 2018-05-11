# frozen_string_literal: true

class UrlTransformer
  class Error
    # Error when key does not exist in redis
    class ResolveKey < UrlTransformer::Error
      def initialize
        super
        @status_code = 404
      end

      def message
        'Unable to resolve key - Not Found'
      end
    end
  end
end
