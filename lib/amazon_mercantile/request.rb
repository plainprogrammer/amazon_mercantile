require 'base64'
require 'openssl'
require 'net/http'

module AmazonMercantile
  class Request
    attr_reader :target, :path, :action, :timestamp, :signature, :response
    attr_accessor :body

    def initialize(verb, path, options)
      @verb = verb.to_s.downcase.to_sym || raise(ArgumentError, 'No Verb Specified')
      @path = path.to_s || raise(ArgumentError, 'No Path Specified')
      @action = options[:action] || raise(ArgumentError, 'No Action Specified')

      raise(ArgumentError, 'Invalid Verb Supplied') unless [:get,:post].include? @verb
    end

    def submit
      prepare
      sign

      @response = AmazonMercantile::Connection.request(self)
      @response.succeeded?
    end

    def content_hash
      [[Digest::MD5.hexdigest(body)].pack("H*")].pack("m").strip
    end

    # Custom Accessors
    def verb
      @verb.to_s.upcase
    end
  private

    def signing_key
      @signing_key
    end

    def canonical_query_string
      @query_string.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
    end

    def prepare
      @target = AmazonMercantile.connection.config.target
      @signing_key = AmazonMercantile.connection.config.secret_key
    end

    def sign
      method = OpenSSL::Digest::Digest.new('sha256')
      message = "#{verb}\n#{target}\n/\n#{canonical_query_string}"
      digest = OpenSSL::HMAC.digest(method, signing_key, message)

      @query_string['Signature'] = Base64.encode64(digest).strip
    end
  end
end
