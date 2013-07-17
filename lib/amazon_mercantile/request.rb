require 'base64'
require 'openssl'
require 'net/http'

module AmazonMercantile
  class Request
    attr_reader :target, :path, :action, :timestamp, :signature, :response

    def initialize(verb, path, options)
      @verb = verb.to_s.downcase.to_sym || raise(ArgumentError, 'No Verb Specified')
      @path = path.to_s || raise(ArgumentError, 'No Path Specified')
      @action = options[:action] || raise(ArgumentError, 'No Action Specified')

      raise(ArgumentError, 'Invalid Verb Supplied') unless [:get,:post].include? @verb
    end

    def submit
      prepare
      sign

      http = Net::HTTP.new(@target, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      klass = "Net::HTTP::#{@verb.to_s.capitalize}".constantize
      request = klass.new("/?#{canonical_query_string}")
      request.body = @body
      request['Content-Type'] = @content_type
      request['Content-MD5']  = [[Digest::MD5.hexdigest(request.body)].pack("H*")].pack("m").strip

      @response = AmazonMercantile::Response.new(http.request(request))
      @response.succeeded?
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
