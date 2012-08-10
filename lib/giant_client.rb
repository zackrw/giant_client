require 'giant_client/net_http_adapter'

class GiantClient
  NotImplementedError = Class.new(StandardError)

  attr_accessor :host, :ssl
  attr_reader :adapter

  def initialize(opts)
    @host = opts[:host] || ""
    @ssl = opts[:ssl] || false
    default_port = @ssl ? 443 : 80
    @port = opts[:port] || default_port

    @adapter = opts[:adapter] || NetHttpAdapter
    @client = @adapter.new
  end

  def adapter=(new_adapter)
    @adapter = new_adapter
    @client = @adapter.new
  end

  def method_missing(method, *args)

    args[0][:ssl] ||= @ssl
    args[0][:host] ||= @host
    args[0][:port] ||= @port
    args[0][:path] ||= '/'
    args[0][:query] ||= {}
    args[0][:headers] ||= {}
    args[0][:body] ||= ''

    @client.__send__(method, *args)
  end

end
