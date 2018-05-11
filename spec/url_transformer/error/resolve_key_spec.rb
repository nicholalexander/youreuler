# frozen_string_literal: true

describe 'ResolveKey' do
  it 'should have a not found status' do
    error = UrlTransformer::Error::ResolveKey.new
    expect(error.status_code).to be(404)
  end

  it 'should have a helpful message' do
    error = UrlTransformer::Error::ResolveKey.new
    expect(error.message).to include('resolve key')
  end
end
