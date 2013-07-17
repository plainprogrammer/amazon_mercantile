require 'amazon_mercantile/version'

require 'amazon_mercantile/connection'
require 'amazon_mercantile/response'
require 'amazon_mercantile/request'

module AmazonMercantile
  def self.establish_connection(options = {})
    @@connection = Connection.new(options)
  end

  def self.connection
    @@connection ||= nil
  end
end
