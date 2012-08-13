require 'giant_client/gc_adapter'
require 'giant_client/gc_response'
require 'typhoeus'

class GiantClient
  class TyphoeusAdapter < GCAdapter
    def initialize
    end

    def request(method, opts)

      if opts[:body] != '' && [:get, :delete, :head].include?(method)
        raise NotImplementedError
      end

      url = url_from_opts(opts)

      params = {}
      params[:method] = method
      params[:headers] = opts[:headers]
      params[:body] = opts[:body]

      response = Typhoeus::Request.run(url, params)

      GCResponse.new(make_response_opts(response))

    end

    def make_response_opts(response)
      opts = {}
      opts[:status_code] = response.code
      opts[:headers] = response.headers_hash
      opts[:body] = response.body
      opts
    end

  end
end
