# frozen_string_literal: true

class UrlShortener
  # Custom base error class
  class Error < StandardError
    attr_reader :status_code

    def initialize
      super
    end

    def to_json
      {
        status_code: status_code,
        message: message
      }
    end
  end
end

class UrlShortener
  # Error when key does not exist in redis
  class ResolveKey < UrlShortener::Error
    def initialize
      @status_code = 404
      super
    end

    def message
      'Unable to resolve key - Not Found'
    end
  end
end
