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
  if development?
    config_file './config/development.yml'
  elsif production?
    config_file './config/production.yml'
  elsif test?
    config_file './config/test.yml'
  end

  REDIS = Redis.new(url: settings.redis_url)
  URL_SHORTENER = UrlShortener.new(settings.base_url, REDIS)
end

get '/' do
  send_file 'views/index.html'
end

get '/*' do
  key = params['splat'].join
  url = REDIS.get(key)
  redirect url
end

namespace '/api' do
  get '/', provides: 'json' do
    json(instructions: 'do this')
  end

  post '/shorten' do
    request_payload = JSON.parse(request.body.read)
    response = URL_SHORTENER.shorten(request_payload)
    json response
  end
end
