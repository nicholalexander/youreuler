# frozen_string_literal: true

describe 'PayloadValidator' do
  it 'should do nothing to a valid payload ' do
    valid_payload = { 'original_url' => 'http://www.google.com' }
    expect { UrlTransformer::PayloadValidator.call(valid_payload) }
      .to_not raise_error
  end

  it 'should raise an error when the payload is missing the original_url key' do
    invalid_payload = { 'some_url' => 'http://www.google.com' }
    expect { UrlTransformer::PayloadValidator.call(invalid_payload) }
      .to raise_error(UrlTransformer::Error::InvalidPayload)
  end

  it 'should raise an error with an invalid slug' do
    invalid_payload = { 'original_url' => 'http://www.google.com',
                        'slug' => '/api/' }
    expect { UrlTransformer::PayloadValidator.call(invalid_payload) }
      .to raise_error(UrlTransformer::Error::InvalidSlug)
  end

  it 'should raise an error with a url without a scheme' do
    invalid_payload = { 'original_url' => 'www.google.com' }
    expect { UrlTransformer::PayloadValidator.call(invalid_payload) }
      .to raise_error(UrlTransformer::Error::InvalidUrl)
  end

  it 'should raise an error with a url without a valid host' do
    invalid_payload = { 'original_url' => 'http://google' }
    expect { UrlTransformer::PayloadValidator.call(invalid_payload) }
      .to raise_error(UrlTransformer::Error::InvalidUrl)
  end
end
