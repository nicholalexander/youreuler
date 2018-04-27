# frozen_string_literal: true

require 'sinatra'
require "sinatra/json"

get '/' do
  "You're Ul"
end

# do we only want to accept json?
get '/api/' do
  pass unless request.accept? 'application/json'
end
