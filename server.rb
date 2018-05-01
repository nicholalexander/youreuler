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
    set :base_url, 'http://youreuler.com/'
  end
  URL_SHORTENER = UrlShortener.new(:redis, settings.base_url)
  if development?
    REDIS = Redis.new(url: 'redis://127.0.0.1:6379/0')
  else
    REDIS = Redis.new(url: 'redis://h:p6bb6ad8c3b93dd220d0d707238dbaf2aab369e5bdab8f0c32d48449ead19b50d@ec2-35-171-63-64.compute-1.amazonaws.com:42449')
  end
end

get '/' do
  "You're Ul"
end

get '/*' do
  # lookup the params and redirect
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
    REDIS.set(response[:short_code], response[:original_url])
    json response
  end
end
