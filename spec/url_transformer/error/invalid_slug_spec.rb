# frozen_string_literal: true

describe 'InvalidSlug' do
  it 'should have a not found status' do
    error = UrlTransformer::Error::InvalidSlug.new
    expect(error.status_code).to be(400)
  end

  it 'should have a helpful message' do
    error = UrlTransformer::Error::InvalidSlug.new
    expect(error.message).to include('api')
  end
end
