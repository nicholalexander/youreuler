require_relative '../server.rb'
require 'rack/test'

set :environment, :test

describe "my server" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  it "should allow a connection at the home page" do
    get '/'
    expect(last_response).to be_ok
  end
end
