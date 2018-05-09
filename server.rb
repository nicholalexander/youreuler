# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'redis'

require './lib/url_shortener'

if development? || test?
  require 'dotenv'
  Dotenv.load

  require 'sinatra/reloader'
  require 'pry'
end

configure do
  redis = Redis.new(url: ENV['REDIS_URL'])
  URL_SHORTENER = UrlShortener.new(ENV['BASE_URL'], redis)
end

handle_api_request_from_params = lambda do
  request_payload = params.select do |key, _value|
    key == 'original_url' || key == 'slug'
  end
  process_payload(request_payload)
end

get '/' do
  send_file 'views/index.html'
end

namespace '/api' do
  get '/' do
    send_file 'views/api_instructions.json'
  end

  post '/shorten' do
    request_payload = JSON.parse(request.body.read)
    process_payload(request_payload)
  end

  post '/shorten/*', &handle_api_request_from_params
  get '/shorten/*', &handle_api_request_from_params
end

get '/*' do
  key = params['splat'].join
  begin
    url = URL_SHORTENER.resolve(key)
    redirect url if url
  rescue UrlShortener::ResolveKeyError => e
    status e.status_code
  end
end

not_found do
  send_file 'views/404.html', status: 404
end

helpers do
  def process_payload(request_payload)
    if URL_SHORTENER.payload_valid?(request_payload)
      response = URL_SHORTENER.shorten(request_payload)
      json response
    else
      status 400
      json(error: "It's you, not me.")
    end
  end
end
