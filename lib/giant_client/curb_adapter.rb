require 'giant_client/abstract_adapter'
require 'curb'

class GiantClient
  class CurbAdapter < AbstractAdapter
    CRLF = /\r\n/
    HEADER_SPLIT = /:\s*/

    def request(method, opts)

      if BODYLESS_METHODS.include?(method)
        raise NotImplementedError unless opts[:body] == ''
      end

      url = url_from_opts(opts)

      if method == :post
        post_body = opts[:body]
      elsif method == :put
        put_data = opts[:body]
      end

      begin
        response = Curl.http( method.upcase, url, post_body, put_data ) do |curl|
          curl.headers = opts[:headers]
          curl.timeout = opts[:timeout]
          curl.connect_timeout = opts[:timeout]
        end
      rescue Curl::Err::TimeoutError
        raise TimeoutError, "the request timed out (timeout: #{opts[:timeout]}"
      end

      normalize_response(response)
    end

    def normalize_response(response)
      status_code = response.response_code
      headers = parse_out_headers(response.header_str)
      body = response.body_str
      Response.new(status_code, headers, body)
    end

    def parse_out_headers(header_string)
      headers = {}
      pairs = header_string.split(CRLF)
      pairs.shift
      pairs.each do |pair|
        header, value = *pair.split(HEADER_SPLIT, 2)
        header = normalize_header(header)
        headers[header] = value
      end
      headers
    end

  end
end
