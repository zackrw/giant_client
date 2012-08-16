class GiantClient
  class MockRequest
    attr_accessor :host, :ssl, :port, :path, :query, :headers, :body, :timeout,
                  :url, :querystring, :raised_error, :error_type

    def raised_error?
      @raised_error
    end
  end
end
