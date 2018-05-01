# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'

require 'sinatra/reloader' if development?
require 'pry' if development?

require './lib/url_shortener'

configure do
  set :environment, :production
  if development?
    set :base_url, 'http://localhost:4567/'
  else
    set :base_url, 'http://youreul.com/'
  end
  url_shortener = UrlShortener.new(:redis, settings.base_url)
  set :url_shortener, url_shortener
end

get '/' do
  "You're Ul"
end

get '/someWierdPattern' do
  redirect 'http://nytimes.com'
end

namespace '/api' do
  get '/', provides: 'json' do
    json(instructions: 'do this')
  end

  post '/shorten' do
    request_payload = JSON.parse(request.body.read)
    response = settings.url_shortener.shorten(request_payload)
    json response
  end
end
