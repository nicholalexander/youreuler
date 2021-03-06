# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

# Setup for Sinatra
require 'rack/test'
ENV['RACK_ENV'] = 'test'
require_relative '../server.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # config.fail_fast = 1

  config.include RSpecMixin
end
