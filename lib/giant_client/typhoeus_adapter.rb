require 'giant_client/abstract_adapter'
require 'typhoeus'

class GiantClient
  class TyphoeusAdapter < AbstractAdapter

    def request(method, opts)

      if BODYLESS_METHODS.include?(method)
        raise GiantClient::Error::NotImplemented unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      params = {}
      params[:method] = method
      params[:headers] = opts[:headers]
      params[:body] = opts[:body]
      params[:timeout] = 1000 * opts[:timeout] # typhoeus does milliseconds
      params[:connect_timeout] = 1000 * opts[:timeout]

      response = Typhoeus::Request.run(url, params)

      if response.curl_return_code == 28 # timeout
        raise GiantClient::Error::Timeout, "the request timed out (timeout: #{opts[:timeout]}"
      end

      normalize_response(response)

    end

    def normalize_response(response)
      status_code = response.code
      headers = normalize_header_hash(response.headers_hash)
      body = response.body
      Response.new(status_code, headers, body)
    end

  end
end
