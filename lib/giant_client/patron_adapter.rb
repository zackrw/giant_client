require 'giant_client/abstract_adapter'
require 'patron'

class GiantClient
  class PatronAdapter < AbstractAdapter

    def request(method, opts)
      if BODYLESS_METHODS.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      http = Patron::Session.new
      http.timeout = opts[:timeout]
      http.connect_timeout = opts[:timeout]

      # TODO support all extra options
      extra_opts = {}
      extra_opts[:data] = opts[:body]
      begin
        response = http.request(method, url, opts[:headers], extra_opts)
      rescue Patron::TimeoutError
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
