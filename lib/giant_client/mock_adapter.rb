require 'giant_client/abstract_adapter'
require 'giant_client/mock_request'

class GiantClient
  class MockAdapter < AbstractAdapter

    attr_accessor :requests, :responses
    def initialize
      @requests = []
      @responses = []
    end

    def request(method, opts)
      last_request = MockRequest.new

      if BODYLESS_METHODS.include?(method)
        unless opts[:body] == ''
          last_request.raised_error = true
          last_request.error_type = GiantClient::Error::NotImplemented
        end
      end

      last_request.host = opts[:host]
      last_request.ssl = opts[:ssl]
      last_request.port = opts[:port]
      last_request.path = opts[:path]
      last_request.query = opts[:query]
      last_request.headers = opts[:headers]
      last_request.body = opts[:body]
      last_request.timeout = opts[:timeout]

      last_request.url = url_from_opts(opts)

      last_request.querystring = stringify_query(opts[:query])

      last_response = { :status_code => 200, :headers => {}, :body => nil }

      @requests.unshift(last_request)
      @responses.unshift(last_response)

      self
    end

    def respond_with(hash)
      @responses[0] = @responses[0].merge(hash)
    end

    def last_request
      @requests[0]
    end

    def last_response
      @responses[0]
    end

  end
end
