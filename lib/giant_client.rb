require 'giant_client/net_http_adapter'
require 'giant_client/patron_adapter'
require 'giant_client/curb_adapter'
require 'giant_client/excon_adapter'
require 'giant_client/typhoeus_adapter'

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

    parse_opts(args[0])
    @client.__send__(method, *args)
  end

  private
  def parse_opts(opts)
    opts[:ssl] ||= @ssl
    opts[:host] ||= @host
    opts[:port] ||= @port
    opts[:path] ||= '/'
    opts[:query] ||= {}
    opts[:headers] ||= {}
    opts[:body] ||= ''
  end

end
