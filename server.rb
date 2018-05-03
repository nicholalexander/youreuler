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

namespace '/api' do
  get '/' do
    json(
      {
        sample_POST_request: {
          original_url: 'http://whatever.com/whatchamacallit'
        },

        sample_response: {
          original_url: 'http://whatever.com/whatchamacallit',
          short_url: 'http://youreuler.com/a3fD2'
        }

    })
  end

  post '/shorten' do
    request_payload = JSON.parse(request.body.read)
    response = URL_SHORTENER.shorten(request_payload)
    json response
  end
end

get '/*' do
  key = params['splat'].join
  url = REDIS.get(key)
  redirect url
end