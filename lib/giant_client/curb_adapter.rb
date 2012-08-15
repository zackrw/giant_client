require 'giant_client/abstract_adapter'
require 'giant_client/gc_response'
require 'curb'

class GiantClient
  class CurbAdapter < AbstractAdapter
    CRLF = /\r\n/
    HeaderSplit = /:\s*/

    def request(method, opts)

      if BodylessMethods.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      if method == :post
        post_body = opts[:body]
      elsif method == :put
        put_data = opts[:body]
      end

      response = Curl.http( method.upcase, url, post_body, put_data ) do |curl|
        curl.headers = opts[:headers]
      end

      normalize_response(response)
    end

    def normalize_response(response)
      status_code = response.response_code
      headers = parse_out_headers(response.header_str)
      body = response.body_str
      GCResponse.new(status_code, headers, body)
    end

    def parse_out_headers(header_string)
      headers = {}
      pairs = header_string.split(CRLF)
      pairs.shift
      pairs.each do |pair|
        header, value = *pair.split(HeaderSplit, 2)
        headers[header] = value
      end
      headers
    end

  end
end
