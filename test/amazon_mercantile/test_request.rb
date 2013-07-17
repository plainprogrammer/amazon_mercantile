require 'minitest_helper'

describe AmazonMercantile::Request do
  let(:valid_request) { AmazonMercantile::Request.new(:post, '/', action: :submit_feed, text_data: 'test') }

  describe '.new' do
    it { lambda{ AmazonMercantile::Request.new() }.must_raise ArgumentError }
    it { lambda{ AmazonMercantile::Request.new(:post) }.must_raise ArgumentError }
    it { lambda{ AmazonMercantile::Request.new(:post, '/') }.must_raise ArgumentError }
  end

  describe '#submit' do
    before :each do
      valid_request.submit
    end

    it { valid_request.timestamp.wont_be_nil }
    it { valid_request.signature.wont_be_nil }
  end

  describe '#response' do
    it { valid_request.response.must_be_instance_of AmazonMercantile::Response }
  end
end
