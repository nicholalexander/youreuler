# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'redis'

require 'sinatra/reloader' if development?
require 'pry' if development?

require './lib/url_shortener'

configure do
  if development?
    set :base_url, 'http://localhost:4567/'
  else
    set :base_url, 'http://youreul.com/'
  end
  URL_SHORTENER = UrlShortener.new(:redis, settings.base_url)
  REDIS = Redis.new(url: 'redis://127.0.0.1:6379/0')
end

get '/' do
  "You're Ul"
end

get '/*' do
  # lookup the params and redirect
  key = params["splat"].join
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
    REDIS.set(response[:short_code], response[:original_url])
    json response
  end
end
