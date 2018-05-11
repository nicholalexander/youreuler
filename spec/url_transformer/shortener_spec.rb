describe "UrlTransformer::Shortener" do
  it 'should have a CODE_LENGTH initialized to 5' do
    expect(UrlTransformer::Shortener::SHORT_CODE_LENGTH).to eq(5)
  end
end
