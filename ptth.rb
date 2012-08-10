class Ptth
  attr_accessor :base, :adapter
  def initialize(opts)
    @base = opts[:base] || ""
    @adapter = opts[:adapter] || Net::HTTP
  end

  def base
    @base
  end

end
