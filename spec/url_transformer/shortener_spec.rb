# frozen_string_literal: true

describe 'UrlTransformer::Shortener' do
  it 'should have a SHORT_CODE_LENGTH initialized to 5' do
    expect(UrlTransformer::Shortener::SHORT_CODE_LENGTH).to eq(5)
  end
end
