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
