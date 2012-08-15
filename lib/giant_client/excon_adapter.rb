require 'giant_client/abstract_adapter'
require 'giant_client/gc_response'
require 'excon'

class GiantClient
  class ExconAdapter < AbstractAdapter

    def request(method, opts)
      if BodylessMethods.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      params = {}
      params[:method]  = method.to_s
      params[:headers] = opts[:headers]
      params[:body]  = opts[:body]

      response = Excon.new(url).request(params)
      normalize_response(response)
    end

    def normalize_response(response)
      status_code = response.status
      headers = response.headers
      body = response.body
      GCResponse.new(status_code, headers, body)
    end
  end
end




