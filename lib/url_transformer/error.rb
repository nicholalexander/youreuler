# frozen_string_literal: true

class UrlTransformer
  # Custom base error class
  class Error < StandardError
    attr_reader :status_code

    def initialize
      super
      @status_code = 500
    end

    def message
      'This is a very serious error - contact customer support immediately.'
    end

    def to_json
      {
        status_code: status_code,
        message: message
      }
    end
  end
end
