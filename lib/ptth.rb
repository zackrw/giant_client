class Ptth

  attr_accessor :base
  attr_reader :adapter

  require 'adapters/net_http_adapter'

  def initialize(opts)
    @base = opts[:base] || ""
    @adapter = opts[:adapter] || NetHttpAdapter
    @client = @adapter.new
  end

  def adapter=(new_adapter)
    @adapter = new_adapter
    @client = @adapter.new
  end

  def method_missing(method, *args)
    args[0][:path] = @base + args[:path]
    @client.method(*args)
  end

end
