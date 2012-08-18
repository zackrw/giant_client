require 'giant_client/response'
require 'giant_client/error'

class GiantClient
  BODYLESS_METHODS = [:get, :delete, :head]

  attr_accessor :host, :ssl, :port
  attr_reader :adapter

  def initialize(*args)

    unless args.length.between?(1, 2)
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)";
    end

    opts = Hash === args.last ? args.last : { :adapter => args.last }
    if String === args.first
      opts[:adapter] = args.first
    end

    @host = opts[:host]
    @ssl = !!opts[:ssl]
    default_port = @ssl ? 443 : 80
    @port = opts[:port] || default_port
    @timeout = opts[:timeout] || 2

    @default_opts = {
      :host => @host,
      :ssl => @ssl,
      :port => @port,
      :path => '/',
      :query => {},
      :headers => {},
      :body => "",
      :timeout => 30
    }

    # default timeouts
    # patron:      5
    # net/http:    60
    # curb:        none
    # excon:       60
    # typhoeus:

    self.adapter = opts[:adapter] || :net_http
    @client = @adapter.new

  end

  def adapter=(new_adapter)
    require "giant_client/#{new_adapter}_adapter"
    normalized = new_adapter.to_s.split('_').map{ |s| s.capitalize }.join
    @adapter = GiantClient.const_get("#{normalized}Adapter")
    @client = @adapter.new
  end

  def method_missing(method, *args)

    unless args.length.between?(1, 2)
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)";
    end

    opts = Hash === args.last ? args.last : { :path => args.last }
    if String === args.first
      opts[:path] = args.first
    end

    opts = @default_opts.merge(opts)
    @client.__send__(method, opts)
  end

  # for the mock adapter only
  def last_request
    if MockAdapter === @client
      @client.last_request
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)";
    end
  end

  def requests
    if MockAdapter === @client
      @client.requests
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)";
    end
  end

  def last_response
    if MockAdapter === @client
      @client.last_response
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)";
    end
  end

  def responses
    if MockAdapter === @client
      @client.responses
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 1..2)";
    end
  end

end
