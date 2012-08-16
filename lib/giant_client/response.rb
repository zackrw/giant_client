class GiantClient
  class Response
    attr_accessor :body, :headers, :status_code

    def initialize(status_code, headers, body)
      @status_code = status_code
      @headers = headers
      @body = body
    end

  end
end
