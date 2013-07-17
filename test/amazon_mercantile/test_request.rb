require 'minitest_helper'

describe AmazonMercantile::Request do
  before :all do
    stub_request(:any, /^https:\/\/mws\.amazonservices\.com/)
  end

  after :all do
    WebMock.reset!
  end

  let(:request) { AmazonMercantile::Request.new(:post, '/', action: :submit_feed, body: 'test') }

  describe '.new' do
    it { lambda{ AmazonMercantile::Request.new() }.must_raise ArgumentError }
    it { lambda{ AmazonMercantile::Request.new(:post) }.must_raise ArgumentError }
    it { lambda{ AmazonMercantile::Request.new(:post, '/') }.must_raise ArgumentError }
  end

  describe '#submit' do
    before :each do
      request.submit
    end

    it { request.timestamp.wont_be_nil }
    it { request.signature.wont_be_nil }
  end

  describe '#response' do
    before :each do
      request.submit
    end

    it { request.response.must_be_instance_of AmazonMercantile::Response }
  end
end
