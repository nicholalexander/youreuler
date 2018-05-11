# frozen_string_literal: true

$stdout.sync = true
require './server'
require 'newrelic_rpm'
run Sinatra::Application
