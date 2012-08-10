require 'net/http'

class GiantClient
  class NetHttpAdapter

    def initialize
    end

    def request(method, opts)
      if opts[:body] != '' && method == :get
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
      http.start {|http| http.request(request)}
      # returns the response

    end

    def get(opts)
      request(:get, opts)
    end

    def post(opts)
      request(:post, opts)
    end

    def put(opts)
      request(:put, opts)
    end

    def delete(opts)
      request(:delete, opts)
    end

    def head(opts)
      request(:head, opts)
    end

  end
end
