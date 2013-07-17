require 'active_support/configurable'
require 'active_support/core_ext/string/inflections'

module AmazonMercantile
  class Connection
    include ActiveSupport::Configurable

    def initialize(options = {})
      config.merchant    = options[:merchant_id] || raise(ArgumentError, 'Merchant ID is required.')
      config.marketplace = options[:marketplace_id] || raise(ArgumentError, 'Marketplace ID is required.')
      config.access_key  = options[:aws_access_key] || raise(ArgumentError, 'AWS Access Key is required.')
      config.secret_key  = options[:aws_secret_key] || raise(ArgumentError, 'AWS Secret Key is required.')

      config.target = options[:target] || 'aws.amazonservices.com'

      setup_http
      self
    end

    def request(request)
      klass = "Net::HTTP::#{request.verb.capitalize}".constantize
      http_request = klass.new("/?#{request.canonical_query_string}")
      http_request.body = request.body
      http_request['Content-Type'] = request.content_type || 'text/xml'
      http_request['Content-MD5']  = request.content_hash
      AmazonMercantile::Response.new(@http.request(http_request))
    end

  private

    def setup_http
      @http = Net::HTTP.new(config.target, 443)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end
end
