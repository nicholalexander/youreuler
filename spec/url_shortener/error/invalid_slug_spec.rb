# frozen_string_literal: true

describe 'ResolveKey' do
  it 'should have a not found status' do
    error = UrlShortener::Error::InvalidSlug.new
    expect(error.status_code).to be(400)
  end

  it 'should have a helpful message' do
    error = UrlShortener::Error::InvalidSlug.new
    expect(error.message).to include('api')
  end
end
