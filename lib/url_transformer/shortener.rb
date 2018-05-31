# frozen_string_literal: true

class UrlTransformer
  # Subclass to handle specifics of shortening.
  class Shortener < UrlTransformer
    SHORT_CODE_LENGTH = 5

    def transform(payload)
      original_url = payload['original_url']

      short_code = generate_unique_code(payload['slug'])
      short_url = build_url(short_code)
      write_to_redis(short_code, build_redis_object(original_url, {}).to_json)
      build_response(original_url, short_url, short_code)
    end

    private

    def build_redis_object(original_url, properties)
      {
          "redirect_to": original_url,
          "properties": properties.to_h
      }
    end

    def generate_code
      (0..SHORT_CODE_LENGTH)
        .map { CHARACTER_SPACE[rand(CHARACTER_SPACE_SIZE)] }.join
    end

    def build_response(original_url, short_url, short_code)
      {
        original_url: original_url,
        short_url: short_url,
        short_code: short_code
      }
    end
  end
end
