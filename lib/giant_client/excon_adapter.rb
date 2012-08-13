require 'giant_client/gc_adapter'
require 'giant_client/gc_response'
require 'excon'

class GiantClient
  class ExconAdapter < GCAdapter
    def initialize
    end

    def request(method, opts)
      if opts[:body] != '' && [:get, :delete, :head].include?(method)
        raise NotImplementedError
      end

      url = url_from_opts(opts)

      params = {}
      params[:method]  = method.to_s
      params[:headers] = opts[:headers]
      params[:body]  = opts[:body]

      response = Excon.new(url).request(params)
      GCResponse.new(make_response_opts(response))

    end
    def make_response_opts(response)
      opts = {}
      opts[:status_code] = response.status
      opts[:headers] = response.headers
      opts[:body] = response.body

      opts
    end
  end
end




