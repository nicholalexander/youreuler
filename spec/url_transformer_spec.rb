# frozen_string_literal: true

require 'url_transformer'
require 'mock_redis'

describe 'UrlTransformer' do
  it 'should have a charachter space' do
    character_space = UrlTransformer::CHARACTER_SPACE
    expect(character_space).to_not be(nil)
  end

  it 'should have upper case and lower case letters' do
    character_space = UrlTransformer::CHARACTER_SPACE
    expect(character_space).to include('x')
    expect(character_space).to include('F')
  end

  it 'should also have numbers' do
    character_space = UrlTransformer::CHARACTER_SPACE
    expect(character_space).to include('3')
  end

  it 'should have a CHARACTER_SPACE_SIZE of 62' do
    size = UrlTransformer::CHARACTER_SPACE_SIZE
    expect(size).to equal(62)
  end

  it 'should have a REDIS_RETRIES initialized to 5' do
    expect(UrlTransformer::REDIS_RETRIES).to eq(5)
  end

  context 'when it is intitialized' do
    before do
      @url_transformer = UrlTransformer.new('base_url', 'redis_client')
    end

    it 'should have a base url' do
      expect(@url_transformer.instance_variable_get(:@base_url))
        .to eq('base_url')
    end

    it 'should have a redis_client' do
      expect(@url_transformer.instance_variable_get(:@redis))
        .to eq('redis_client')
    end
  end

  describe '#shorten' do
    before do
      @redis_instance = spy(MockRedis.new)
      allow(@redis_instance).to receive(:exists).and_return(false)
      @url_transformer = UrlTransformer.new('http://base_url/', @redis_instance)
      payload = { 'original_url' => 'http://google.com/' }
      @response = @url_transformer.shorten(payload)
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

    it 'should return a short code built from the character_space' do
      expect(@response[:short_code].split('').all? do |x|
        UrlTransformer::CHARACTER_SPACE.include?(x)
      end).to be true
    end

    it 'should persist in redis' do
      expect(@redis_instance).to have_received(:setnx)
        .with(anything, %r{http:\/\/google.com})
    end

    context 'when a slug is provided' do
      it 'should include the slug in the shortened url' do
        payload = {
          'original_url' => 'http://google.com/',
          'slug' => '/blurgh'
        }
        @response = @url_transformer.shorten(payload)

        expect(@response[:short_code].include?('blurgh')).to be true
      end

      it 'should handle slashes at the beginning and end of the slug' do
        payload = {
          'original_url' => 'http://google.com/',
          'slug' => '/blurgh/'
        }
        @response = @url_transformer.shorten(payload)
        expect(@response[:short_url]).to match(%r{base_url\/blurgh\/})
      end
    end

    context 'when a slug is not provided' do
      it 'should return a short url in the form of http://base_url/code' do
        expect(@response[:short_url]).to match(%r{http:\/\/\S*\/\S{6}})
      end
    end

    context 'when the redis keyspace is full' do
      it 'should raise an error with a message about the keyspace' do
        allow(@redis_instance).to receive(:exists).and_return(true)
        payload = { 'original_url' => 'http://google.com/' }
        expect { @url_transformer.shorten(payload) }
          .to raise_error(RuntimeError, /Keyspace/)
      end
    end
  end

  describe '#resolve' do
    it 'should return a code from redis' do
      @redis_instance = spy(MockRedis.new)
      allow(@redis_instance).to receive(:get)
        .and_return('http://some_full_long_url')
      @url_transformer = UrlTransformer.new('http://base_url/', @redis_instance)

      expect(@url_transformer.resolve('valid_short_code'))
        .to eq('http://some_full_long_url')
    end
  end
end
