require 'minitest_helper'

describe AmazonMercantile do
  before :each do
    @valid_options = {
        merchant_id:    '12345SAMPLE',
        marketplace_id: '12345SAMPLE',
        aws_access_key: '12345SAMPLE',
        aws_secret_key: '12345SAMPLE'
    }
  end

  describe '.establish_connection' do
    it { AmazonMercantile.establish_connection(@valid_options).must_be_kind_of AmazonMercantile::Connection }

    describe 'invalid options' do
      it { lambda{AmazonMercantile.establish_connection({
        marketplace_id: '12345SAMPLE',
        aws_access_key: '12345SAMPLE',
        aws_secret_key: '12345SAMPLE'
      })}.must_raise ArgumentError}

      it { lambda{AmazonMercantile.establish_connection({
        merchant_id:    '12345SAMPLE',
        aws_access_key: '12345SAMPLE',
        aws_secret_key: '12345SAMPLE'
      })}.must_raise ArgumentError}

      it { lambda{AmazonMercantile.establish_connection({
        merchant_id:    '12345SAMPLE',
        marketplace_id: '12345SAMPLE',
        aws_secret_key: '12345SAMPLE'
      })}.must_raise ArgumentError}

      it { lambda{AmazonMercantile.establish_connection({
        merchant_id:    '12345SAMPLE',
        marketplace_id: '12345SAMPLE',
        aws_access_key: '12345SAMPLE',
      })}.must_raise ArgumentError}
    end
  end

  describe '.connection' do
    it { AmazonMercantile.connection.must_be_instance_of AmazonMercantile::Connection }
  end
end
