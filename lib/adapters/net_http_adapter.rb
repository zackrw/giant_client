class NetHttpAdapter

  require 'net/http'

  def initialize
  end

  def get(url)
    Net::HTTP.get(url)
  end

end
