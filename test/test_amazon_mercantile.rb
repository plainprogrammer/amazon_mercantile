require 'minitest_helper'

describe AmazonMercantile do
  let(:valid_options) {
    {
      merchant_id:    '',
      marketplace_id: '',
      access_key:     '',
      secret_key:     ''
    }
  }

  describe '.establish_connection' do
    it { AmazonMercantile.establish_connection(valid_options).must_equal true }
  end

  describe '.connection' do
    before(:each) do
      AmazonMercantile.establish_connection(valid_options)
    end

    it { AmazonMercantile.connection.must_be_instance_of AmazonMercantile::Connection }
  end
end
