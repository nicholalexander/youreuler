# For shortening.
class UrlTransformer
  class Shortener < UrlTransformer
    SHORT_CODE_LENGTH = 5

    def transform(payload)
      original_url = payload['original_url']

      short_code = generate_unique_code(payload['slug'])
      short_url = build_url(short_code)

      write_to_redis(short_code, original_url)
      build_response(original_url, short_url, short_code)
    end

    private

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