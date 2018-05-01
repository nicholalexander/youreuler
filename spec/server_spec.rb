# frozen_string_literal: true

describe 'the server' do
  it 'should allow access to the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'should have some basic instructions on the home page' do
    get '/'
    expect(last_response.body).to include('api/shorten')
  end
end
