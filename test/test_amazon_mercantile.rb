require 'minitest_helper'

describe AmazonMercantile do
  let(:valid_options) {
    {
      merchant_id:    '12345SAMPLE',
      marketplace_id: '12345SAMPLE',
      aws_access_key: '12345SAMPLE',
      aws_secret_key: '12345SAMPLE'
    }
  }

  describe '.establish_connection' do
    it { AmazonMercantile.establish_connection(valid_options).must_be_kind_of AmazonMercantile::Connection }
  end

  describe '.connection' do
    it { AmazonMercantile.connection.must_be_instance_of AmazonMercantile::Connection }
  end
end
