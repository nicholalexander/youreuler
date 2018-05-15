# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'newrelic_rpm'
require 'redis'

require './lib/url_transformer'

if development? || test?
  require 'dotenv'
  Dotenv.load

  require 'sinatra/reloader'
  require 'pry'
end

configure do
  redis = Redis.new(url: ENV['REDIS_URL'])
  URL_TRANSFORMER = UrlTransformer.new(ENV['BASE_URL'], redis)
end

handle_api_request_from_params = lambda do
  request_payload = params.select do |key, _value|
    key == 'original_url' || key == 'slug'
  end
  process_payload(request_payload)
end

get '/?' do
  send_file 'views/index.html'
end

get '/expired' do
  send_file 'views/expired.html'
end

get '/loaderio-956ae1ea465e5c4992b272052969f6a3/' do
  send_file 'loaderio-956ae1ea465e5c4992b272052969f6a3.txt'
end

namespace '/api' do
  get '/?' do
    send_file 'views/api_instructions.json'
  end

  post '/shorten' do
    request_payload = JSON.parse(request.body.read)
    process_payload(request_payload)
  end

  post '/enlengthen' do
    request_payload = JSON.parse(request.body.read)
    process_payload(request_payload, :enlengthen)
  end

  post '/shorten/*', &handle_api_request_from_params
  get '/shorten/*', &handle_api_request_from_params
end

get '/*' do
  key = params['splat'].join
  begin
    url = URL_TRANSFORMER.resolve(key)
    redirect url if url
  rescue UrlTransformer::Error::ResolveKey => e
    status e.status_code
  end
end

not_found do
  send_file 'views/404.html', status: 404
end

helpers do
  def process_payload(request_payload, mode = :shorten)
    UrlTransformer::PayloadValidator.call(request_payload)
    if mode == :shorten
      response = URL_TRANSFORMER.shorten(request_payload)
    elsif mode == :enlengthen
      response = URL_TRANSFORMER.enlengthen(request_payload)
    end

    json response
  rescue UrlTransformer::Error => e
    status e.status_code
    json e.to_json
  end
end
