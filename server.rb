# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'pry'

require './lib/url_shortener'

configure do
  url_shortener = UrlShortener.new(:redis)
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
