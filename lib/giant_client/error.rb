class GiantClient
  class Error < StandardError

    class NotImplemented < Error; end
    class Timeout        < Error; end

  end
end
