class GiantClient
  class AbstractAdapter

    def url_from_opts(opts)
      query = encode_query(opts[:query])

      if opts[:ssl]
        scheme = 'https://'
        port = opts[:port] == 443 ? '' : ":#{opts[:port]}"
      else
        scheme = 'http://'
        port = opts[:port] == 80 ? '' : ":#{opts[:port]}"
      end

      "#{scheme}#{opts[:host]}#{port}#{opts[:path]}#{query}"
    end

    def encode_query(query)
      query = stringify_query(query)
      query = prepend_question_mark(query) unless query == ''
      query
    end

    def stringify_query(query)
      if Hash === query
        query = URI.encode_www_form(query)
      end
      query
    end

    def prepend_question_mark(str)
      "?#{str}"
    end

    def normalize_header_hash(headers)
      normalized_headers = {}
      headers.each do |header, value|
        normalized = normalize_header(header)
        normalized_headers[normalized] = value
      end
      normalized_headers
    end

    def normalize_header(header)
      header.split('-').map{|h| h.capitalize}.join('-')
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
