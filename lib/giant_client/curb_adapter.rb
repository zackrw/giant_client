require 'giant_client/gc_adapter'
require 'giant_client/gc_response'
require 'curb'

class GiantClient
  class CurbAdapter < GCAdapter
    def initialize
    end

    def request(method, opts)
      method = method.upcase

      if opts[:body] != '' && [:GET, :DELETE, :HEAD].include?(method)
        raise NotImplementedError
      end

      url = url_from_opts(opts)

      post_body, put_data = nil, nil

      if method == :POST
        post_body = opts[:body]
      elsif method == :PUT
        put_data = opts[:body]
      end

      response = Curl.http( method, url, post_body, put_data ) do |curl|
        curl.headers = opts[:headers]
      end

      GCResponse.new(make_response_opts(response))
    end

    def make_response_opts(response)
      opts = {}
      opts[:status_code] = response.response_code
      opts[:headers] = parse_out_headers(response.header_str)
      opts[:body] = response.body_str
      opts
    end

    def parse_out_headers(header_string)
      headers = {}
      pairs = header_string.split(/\r\n/)
      pairs.shift
      pairs.each do |pair|
        split_pair = pair.split(/\:\s*/)
        headers[split_pair[0].capitalize] = split_pair[1]
      end
      headers
    end

  end
end
