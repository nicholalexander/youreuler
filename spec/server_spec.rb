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

  describe 'the api' do
    it 'should have a sample response on the api namespace' do
      get '/api/'
      expect(JSON.parse(last_response.body).keys)
        .to eq(['sample_POST_request to /api/shorten should contain json',
                'sample_response'])
    end

    context 'with a valid body type' do
      it 'should respond with a shortened url' do
        body = { original_url: 'http://google.com' }.to_json
        post '/api/shorten', body, 'CONTENT_TYPE' => 'application/json'
        expect(JSON.parse(last_response.body).keys)
          .to eq(%w[original_url short_url short_code])
      end
    end

    context 'with missing original_url' do
      it 'should return a 400' do
        body = { BAD_KEY: 'http://someurl' }.to_json
        post '/api/shorten', body, 'CONTENT_TYPE' => 'application/json'
        expect(last_response.status).to eq(400)
      end
    end
  end
end
