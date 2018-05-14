# frozen_string_literal: true

describe 'InvalidUrl' do
  it 'should have a not found status' do
    error = UrlTransformer::Error::InvalidUrl.new
    expect(error.status_code).to be(400)
  end

  it 'should have a helpful message' do
    error = UrlTransformer::Error::InvalidUrl.new
    expect(error.message).to include('Url invalid')
  end
end
