class UrlShortener
  class PayloadValidator

    def self.call(payload)
      check_original_url(payload)
    end
  
    private
    
    def self.check_original_url(payload)
        raise UrlShortener::Error::InvalidPayload unless
          payload.keys.include? 'original_url'
    end

  end
end
