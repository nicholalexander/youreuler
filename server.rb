# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'sinatra/config_file'
require 'redis'

require './lib/url_shortener'

if development?
  require 'sinatra/reloader'
  require 'pry'
end

configure do
  if development? || test?
    config_file './config/development.yml'
  elsif production?
    config_file './config/production.yml'
  end

  REDIS = Redis.new(url: settings.redis_url)
  URL_SHORTENER = UrlShortener.new(settings.base_url, REDIS)
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
  url = REDIS.get(key)
  redirect url
end
