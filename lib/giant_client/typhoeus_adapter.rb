require 'giant_client/abstract_adapter'
require 'giant_client/gc_response'
require 'typhoeus'

class GiantClient
  class TyphoeusAdapter < AbstractAdapter

    def request(method, opts)

      if BodylessMethods.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      params = {}
      params[:method] = method
      params[:headers] = opts[:headers]
      params[:body] = opts[:body]

      response = Typhoeus::Request.run(url, params)

      normalize_response(response)

    end

    def normalize_response(response)
      status_code = response.code
      headers = response.headers_hash
      body = response.body
      GCResponse.new(status_code, headers, body)
    end

  end
end
