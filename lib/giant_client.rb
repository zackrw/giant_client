
class GiantClient
  BodylessMethods = [:get, :delete, :head]
  NotImplementedError = Class.new(StandardError)

  attr_accessor :host, :ssl, :port
  attr_reader :adapter

  def initialize(opts)
    @host = opts[:host]
    @ssl = !!opts[:ssl]
    default_port = @ssl ? 443 : 80
    @port = opts[:port] || default_port

    @default_opts = {
      :host => @host,
      :ssl => @ssl,
      :port => @port,
      :path => '/',
      :query => {},
      :headers => {},
      :body => ""
    }

    self.adapter = opts[:adapter] || :net_http
    @client = @adapter.new

  end

  def adapter=(new_adapter)
    require "giant_client/#{new_adapter}_adapter"
    normalized = new_adapter.to_s.split('_').map(&:capitalize).join
    @adapter = GiantClient.const_get("#{normalized}Adapter")
    @client = @adapter.new
  end

  def method_missing(method, *args)

    unless args.length.between?(1, 2)
      raise ArgumentError, 'Wrong Number of Arguments (>2 for [1..2])';
    end

    opts = Hash === args.last ? args.last : { :path => args.last }
    if String === args.first
      opts[:path] = args.first
    end

    opts = parse_opts(opts)
    @client.__send__(method, opts)
  end

  private
  def parse_opts(opts)
    @default_opts.merge(opts)
  end

end
