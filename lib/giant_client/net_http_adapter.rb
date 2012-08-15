require 'giant_client/abstract_adapter'
require 'giant_client/gc_response'
require 'net/http'

class GiantClient
  class NetHttpAdapter < AbstractAdapter

    def request(method, opts)
      if BodylessMethods.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end
      query = encode_query(opts[:query])

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

      if request.request_body_permitted?
        request.body = opts[:body]
      end

      response = http.start {|http| http.request(request)}

      # make response object
      normalize_response(response)
    end

    def normalize_response(response)
      status_code = response.code.to_i
      headers = {}
      response.each_header do |header, value|
        headers[header.capitalize] = value
      end
      body = response.body
      GCResponse.new(status_code, headers, body)
    end

  end
end
