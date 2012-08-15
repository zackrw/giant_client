require 'giant_client/abstract_adapter'
require 'patron'

class GiantClient
  class PatronAdapter < AbstractAdapter

    def request(method, opts)
      if BodylessMethods.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      http = Patron::Session.new

      # TODO support all extra options
      extra_opts = {}
      extra_opts[:data] = opts[:body]
      response = http.request(method, url, opts[:headers], extra_opts)

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
