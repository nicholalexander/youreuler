# frozen_string_literal: true

require 'newrelic_rpm'

$stdout.sync = true
require './server'
run Sinatra::Application
