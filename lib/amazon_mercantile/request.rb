module AmazonMercantile
  class Request
    attr_reader :verb, :path, :action, :timestamp, :signature, :response

    def initialize(verb, path, options)
      @verb = verb.to_s.downcase.to_sym || raise(ArgumentError, 'No Verb Specified')
      @path = path.to_s || raise(ArgumentError, 'No Path Specified')
      @action = options[:action] || raise(ArgumentError, 'No Action Specified')

      raise(ArgumentError, 'Invalid Verb Supplied') unless [:get,:post].include? @verb
    end

    def submit
      prepare
      sign

    end

  private

    def prepare

    end

    def sign

    end
  end
end
