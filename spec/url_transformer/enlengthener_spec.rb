# frozen_string_literal: true

require 'mock_redis'

describe 'UrlTransformer::Shortener' do
  it 'should have a LONG_CODE_LENGTH initialized to 256' do
    expect(UrlTransformer::Shortener::LONG_CODE_LENGTH).to eq(256)
  end

  describe '#enlengthen' do
    before do
      @redis_instance = spy(MockRedis.new)
      allow(@redis_instance).to receive(:exists).and_return(false)
      @url_transformer = UrlTransformer.new('http://base_url/', @redis_instance)
      payload = { 'original_url' => 'http://google.com/' }
      @response = @url_transformer.enlengthen(payload)
    end

    it 'should have the right keys in the response' do
      expect(@response.keys.include?(:original_url)).to be true
      expect(@response.keys.include?(:long_url)).to be true
      expect(@response.keys.include?(:long_code)).to be true
    end

    it 'should have a long link' do
      expect(@response[:long_url].length).to be > 256
    end
  end
end
