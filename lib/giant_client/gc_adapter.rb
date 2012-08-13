class GiantClient
  class GCAdapter
    def initialize
    end

    def url_from_opts(opts)
      query = opts[:query]
      case query
      when Hash
        query = URI.encode_www_form(opts[:query])
      end
      query = "?#{query}" unless query == ''

      if opts[:ssl]
        scheme = 'https://'
        port = opts[:port] == 443 ? '' : ":#{opts[:port]}"
      else
        scheme = 'http://'
        port = opts[:port] == 80 ? '' : ":#{opts[:port]}"
      end

      scheme + opts[:host] + port + opts[:path] + query
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
