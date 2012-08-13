class GiantClient
  class GCResponse
    attr_accessor :body, :headers, :status_code

    def initialize(opts)
      @body = opts[:body] || ''
      @headers = opts[:headers] || {}
      @status_code = opts[:status_code] || '999'
    end
  end
end
