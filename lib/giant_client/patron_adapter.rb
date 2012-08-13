require 'giant_client/gc_adapter'
require 'patron'

class GiantClient
  class PatronAdapter < GCAdapter
    def initialize
    end

    def request(method, opts)
      if opts[:body] != '' && [:get, :delete, :head].include?(method)
        raise NotImplementedError
      end

      url = url_from_opts(opts)

      http = Patron::Session.new

      # TODO support all extra options
      extra_opts = {}
      extra_opts[:data] = opts[:body]
      response = http.request(method, url, opts[:headers], extra_opts)

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
