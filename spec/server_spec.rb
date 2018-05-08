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

    describe '/api/shorten' do
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

      context 'when the arguments are in the parameters' do
        it 'should return a good response' do
          post '/api/shorten/?original_url=http://google.com&slug=/blurgh/'
          expect(JSON.parse(last_response.body).keys)
            .to eq(%w[original_url short_url short_code])
        end
      end
    end

    describe '/*' do
      context 'when a key is found' do
        before do
          @original_url_shortener = URL_SHORTENER
          stub_const('URL_SHORTENER', double(URL_SHORTENER))
        end

        it 'should redirect to a url' do
          allow(URL_SHORTENER).to receive(:resolve)
            .and_return('http://google.com')

          get '/some_valid_short_code'

          expect(last_response.status).to eq(302)
          expect(last_response.header['Location']).to eq('http://google.com')
        end
      end

      context 'when no key is found' do
        it 'should return a 404' do
          get '/slug/shortcode'
          expect(last_response.status).to eq(404)
        end
      end
    end
  end
end
