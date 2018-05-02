# frozen_string_literal: true
require 'pry'
require 'url_shortener'
require 'mock_redis'

describe 'UrlShortener' do
  it 'should have a charachter space' do
    character_space = UrlShortener::CHARACTER_SPACE
    expect(character_space).to_not be(nil)
  end

  it 'should have upper case and lower case letters' do
    character_space = UrlShortener::CHARACTER_SPACE
    expect(character_space).to include('x')
    expect(character_space).to include('F')
  end

  it 'should also have numbers' do
    character_space = UrlShortener::CHARACTER_SPACE
    expect(character_space).to include('3')
  end

  it 'should have a CHARACTER_SPACE_SIZE of 62' do
    size = UrlShortener::CHARACTER_SPACE_SIZE
    expect(size).to equal(62)
  end

  context 'when it is intitialized' do
    before do
      @url_shortener = UrlShortener.new('base_url', 'redis_client')
    end

    it 'should have a base url' do
      expect(@url_shortener.instance_variable_get(:@base_url)).to eq('base_url')
    end

    it 'should have a redis_client' do
      expect(@url_shortener.instance_variable_get(:@redis)).to eq('redis_client')
    end
  end

  describe '#shorten' do
    before do
      @redis_instance = spy(MockRedis.new)
      url_shortener = UrlShortener.new('http://base_url/', @redis_instance)
      payload = { 'original_url' => 'http://google.com/' }
      @response = url_shortener.shorten(payload)
    end

    it 'should return a response with the original_url' do
      expect(@response[:original_url]).to eq('http://google.com/')
    end

    it 'should return a response with the shortened url' do
      expect(@response[:short_url].length).to be > 5
    end

    it 'should return a valid http url for the shortened url' do
      url = URI.parse(@response[:short_url])
      expect(url.is_a?(URI::HTTP)).to be true
    end

    it 'should return a short code that has characters from the character_space' do
      expect(@response[:short_code].split('').all? { |x| UrlShortener::CHARACTER_SPACE.include?(x)}).to be true
    end

    it 'should persist in redis' do
      expect(@redis_instance).to have_received(:set).with(anything, /http:\/\/google.com/)
    end
  
    context 'when a slug is provided' do
      it 'should include the slug in the shortened url'

    end
  end

  
  

end
