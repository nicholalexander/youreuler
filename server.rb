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

get '/' do
  send_file 'views/index.html'
end

namespace '/api' do
  get '/' do
    content_type :json
    send_file 'views/api_instructions.json'
  end

  post '/shorten' do
    request_payload = JSON.parse(request.body.read)
    if URL_SHORTENER.payload_valid?(request_payload)
      response = URL_SHORTENER.shorten(request_payload)
      json response
    else
      status 400
      json(error: "It's you, not me.")
    end
  end
end

get '/*' do
  key = params['splat'].join
  url = URL_SHORTENER.resolve(key)
  redirect url if url
  status 404
end

not_found do
  send_file 'views/404.html', status: 404
end
