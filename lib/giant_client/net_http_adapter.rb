require 'giant_client/gc_adapter'
require 'giant_client/gc_response'
require 'net/http'

class GiantClient
  class NetHttpAdapter < GCAdapter

    def initialize
    end

    def request(method, opts)
      if opts[:body] != '' && [:get, :delete, :head].include?(method)
        raise NotImplementedError
      end
      query = opts[:query]
      case query
      when Hash
        query = URI.encode_www_form(opts[:query])
      end
      query = "?#{query}" unless query == ''

      http = Net::HTTP.new( opts[:host], opts[:port] )
      http.use_ssl = opts[:ssl]

      request_class =
        case method
          when :get then Net::HTTP::Get
          when :post then Net::HTTP::Post
          when :put then Net::HTTP::Put
          when :delete then Net::HTTP::Delete
          when :head then Net::HTTP::Head
        end

      request = request_class.new( opts[:path] + query, opts[:headers] )

      unless method == :get
        request.body = opts[:body]
      end
      response = http.start {|http| http.request(request)}

      # make response object

      GCResponse.new(make_response_opts(response))
    end
    def make_response_opts(response)
      opts = {}
      opts[:status_code] = response.code.to_i
      opts[:headers] = {}
      response.each_header do |header, value|
        opts[:headers][header.capitalize] = value
      end
      opts[:body] = response.body
      opts
    end

  end
end
