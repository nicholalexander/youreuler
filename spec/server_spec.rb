describe 'the server' do
  it 'should all access to the home page' do
    get '/'
    expect(last_response).to be_ok
  end
end
