# frozen_string_literal: true
require 'pry'

describe 'the server' do
  it 'should allow access to the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'should have some basic instructions on the home page' do
    get '/'
    expect(last_response.body).to include('api/shorten')
  end

  it 'should have a sample response on the api namespace' do
    get '/api/'
    expect(JSON.parse(last_response.body).keys)
      .to eq(["sample_POST_request", "sample_response"])
  end

end
