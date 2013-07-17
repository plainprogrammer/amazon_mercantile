require 'base64'
require 'openssl'
require 'net/http'

require 'active_support/core_ext/time'

module AmazonMercantile
  class Request
    attr_reader :target, :path, :response
    attr_accessor :body, :content_type

    def initialize(verb, path, options)
      @query_string = {}

      @target = AmazonMercantile.connection.config.target
      @verb = verb.to_s.downcase.to_sym || raise(ArgumentError, 'No Verb Specified')
      @path = path.to_s || raise(ArgumentError, 'No Path Specified')
      @query_string['Action'] = options[:action] || raise(ArgumentError, 'No Action Specified')
      @body = options[:body] || ''

      raise(ArgumentError, 'Invalid Verb Supplied') unless [:get,:post].include? @verb
    end

    def submit
      prepare
      sign

      @response = AmazonMercantile.connection.request(self)
      response.succeeded?
    end

    def content_hash
      [[Digest::MD5.hexdigest(body)].pack("H*")].pack("m").strip
    end

    def query_string
      @query_string.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
    end

    # Custom Accessors
    def verb
      @verb.to_s.upcase
    end

    def action
      @query_string['Action']
    end

    def signature
      @query_string['Signature']
    end

    def timestamp
      @query_string['Timestamp']
    end
  private

    def prepare
      @query_string['Timestamp'] = Time.now.iso8601
      @query_string['Marketplace'] = AmazonMercantile.connection.config.marketplace
      @query_string['AWSAccessKeyId'] = AmazonMercantile.connection.config.access_key
      @query_string['Merchant'] = AmazonMercantile.connection.config.merchant
      @query_string['Version'] = '2009-01-01'
    end

    def sign
      @query_string['SignatureVersion'] = 2
      @query_string['SignatureMethod'] = 'HmacSHA256'

      signing_key = AmazonMercantile.connection.config.secret_key

      method = OpenSSL::Digest::Digest.new('sha256')
      message = "#{verb}\n#{target}\n/\n#{query_string}"
      digest = OpenSSL::HMAC.digest(method, signing_key, message)

      @query_string['Signature'] = Base64.encode64(digest).strip
    end
  end
end
