require 'giant_client/abstract_adapter'
require 'excon'

class GiantClient
  class ExconAdapter < AbstractAdapter

    def request(method, opts)
      if BODYLESS_METHODS.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      params = {}
      params[:method]  = method.to_s
      params[:headers] = opts[:headers]
      params[:body]  = opts[:body]
      params[:read_timeout]  = opts[:timeout]
      params[:connect_timeout]  = opts[:timeout]
      params[:write_timeout]  = opts[:timeout]

      begin
        response = Excon.new(url).request(params)
      rescue Excon::Errors::Timeout
        raise TimeoutError, "the request timed out (timeout: #{opts[:timeout]}"
      end

      normalize_response(response)
    end

    def normalize_response(response)
      status_code = response.status
      headers = normalize_header_hash(response.headers)
      body = response.body
      Response.new(status_code, headers, body)
    end
  end
end




