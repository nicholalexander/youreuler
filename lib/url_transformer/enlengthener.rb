# frozen_string_literal: true

class UrlTransformer
  # Subclass to handle specifics of longening.
  class Enlengthener < UrlTransformer
    LONG_CODE_LENGTH = 256

    def transform(payload)
      original_url = payload['original_url']

      long_code = generate_unique_code(payload['slug'])
      long_url = build_url(long_code)

      write_to_redis(long_code, original_url)
      build_response(original_url, long_url, long_code)
    end

    private

    def generate_code
      (0..LONG_CODE_LENGTH)
        .map { CHARACTER_SPACE[rand(CHARACTER_SPACE_SIZE)] }.join
    end

    def build_response(original_url, long_url, long_code)
      {
        original_url: original_url,
        long_url: long_url,
        long_code: long_code
      }
    end
  end
end
