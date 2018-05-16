# frozen_string_literal: true

require 'securerandom'

class UrlTransformer
  # Subclass to handle specifics of longening.
  class Enlengthener < UrlTransformer
    LONG_CODE_LENGTH = 256

    def transform(payload)
      original_url = payload['original_url']

      long_code = generate_unique_code(payload['slug'])
      long_url = build_url(long_code)

      if payload['properties']
        properties = process_link_properties(payload['properties'], original_url)
      else
        properties = {}
      end

      write_to_redis(long_code, build_redis_object(original_url, properties).to_json)
      build_response(original_url, long_url, long_code, properties)
    end

    private

    def generate_code
      SecureRandom.urlsafe_base64(256)
    end

    def process_link_properties(properties, original_url)
      output_properties_hash = process_expiration(properties['expires_after']) if properties['expires_after']
      output_properties_hash.merge!(process_verification(properties['keybase_verified'], original_url)) if properties['keybase_verified']
    end

    def process_expiration(expiration_data)
      OpenStruct.new(expiration_data).to_h
    end

    def build_redis_object(original_url, properties)
      {
          "redirect_to": original_url,
          "properties": properties.to_h
      }
    end

    def process_verification(message, original_url)
      verifier = Verifier.new(message['data'], message['keybase_username'])
      verified = verifier.verify
      if verified
        url = verifier.get_url

        raise "Not verified" unless (url == original_url)
      end
      {
        verification: {
          verified: true,
          details: message.to_h
        }
      }
    end

    def build_response(original_url, long_url, long_code, properties)
      {
        original_url: original_url,
        long_url: long_url,
        long_code: long_code
      }.merge({properties: properties.to_h})
    end
  end
end
