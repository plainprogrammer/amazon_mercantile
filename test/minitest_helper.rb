require 'bundler/setup'

unless ENV['COVERAGE'] == 'no'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end
end

require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'

require 'amazon_mercantile'

AmazonMercantile.establish_connection(
    merchant_id:    '12345SAMPLE',
    marketplace_id: '12345SAMPLE',
    aws_access_key: '12345SAMPLE',
    aws_secret_key: '12345SAMPLE'
)
