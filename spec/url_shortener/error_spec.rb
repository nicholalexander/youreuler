# frozen_string_literal: true

describe 'Error' do
  it 'should be a standard error' do
    expect(UrlShortener::Error.superclass).to eq(StandardError)
  end

  describe '#to_json' do
    it 'should have a json_representation with status_code' do
      error = UrlShortener::Error.new
      expect(error.to_json.keys).to include(:status_code)
    end

    it 'should have a json_representation with a message' do
      error = UrlShortener::Error.new
      expect(error.to_json.keys).to include(:status_code)
    end

    it 'should have a meaningful defaults' do
      error = UrlShortener::Error.new
      expect(error.status_code).to eq(500)
      expect(error.message.empty?).to be false
    end
  end
end
