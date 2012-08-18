##Giant Client

Giant Client is a ruby library which exposes a simple and uniform API for
using a variety of http clients. Advantages of Giant Client:
* Clean, easy-to-use, cruftless API
* Testing as simple as it gets with a built in test framework that uses the exact same API
* Take advantage of 5+ http clients while only learning one API
* Seamlessly swap between http clients with one line of configuration (rather than erasing all of your code)


## Installation

*Note: not yet available*

Add this line to your application's Gemfile:

    gem 'giant_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install giant_client

## Usage
*In this guide, I am very exhaustive with options, so it seems long winded, but this is just to show all configuration options, most are optional.*

####Initialize a new Giant Client
    options = {
      :host => "www.example.com",  # optional, defaults to ""
      :ssl => true,                # optional, defaults to false
      :port => 443,                # optional, defaults to 443 when ssl == true,
                                   #                 and to 80 when ssl == false
      :adapter => :typhoeus  # optional, defaults to :net_http, options detailed below
    }

    client = GiantClient.new(options)

######Passing a symbol argument as the first argument to initialize is assumed to be the adapter
######short hand
    client = GiantClient.new :patron, :host => 'example.com'

####Adapters
*There are currently five adapters supported. They use the libraries they are named after.*
    :net_http
    :patron
    :excon
    :curb
    :typhoeus

####The API
Giant Client supports the HTTP 'GET', 'POST', 'PUT', 'DELETE', and 'HEAD' methods
*The 'GET', 'DELETE', and 'HEAD' methods do not support a request body. Attempting to pass one will cause Giant Client to throw a NotImplementedError*
#####All methods support ssl, host, port, path, query, headers, and body as options.

#####Note:
*ssl defaults to ssl provided in new (true here)*
*host defaults to host provided in new ('www.example.com' here)*
*port defaults to port provided in new ('443' here)*


######GET
    client.get({
      :path => '/path/to/resource',                    # optional, defaults to '/'
      :headers => { 'Accepts' => 'application/json' }, # optional, defaults to {}
      :query => { 'post_id' => '29' }                  # optional, defaults to {}
    })
######POST
    client.post({
      :path => '/path/to/resource',                    # optional, defaults to '/'
      :body => 'hey, how\'s it going?',                # optional, defaults to ''
    })
######PUT
    client.put({
      :path => '/path/to/resource',                    # optional, defaults to '/'
      :body => 'hey, how\'s it going?'                # optional, defaults to ''
    })
######DELETE
    client.delete({
      :path => '/path/to/resource?for_good=true'
    })
######HEAD
    client.head({
      :path => '/path/to/resource'
    })
######Giant Client also exposes a general `request` method, which each method calls under the hood.
    client.request(:get, {
      :path => '/search?q=ahoy',
    })

####Return Value
All of Giant Client's request methods return a uniform response object. This object has accessors for `status_code`, `headers`, and `body`
In general, `status_code` is a number, `headers` is a Hash, and `body` is a String.
######Example
    response = client.request(:get, {
      :path => '/search?q=ahoy',
    })
    puts response.status_code  # e.g. 200
    puts response.headers      # e.g. {'Content-Type' => 'application/json' }
    puts response.body         # e.g. 'ahoy matee'

######Giant Client provides getters and setters to default port, host, and ssl.
    # one request over http on port 80
    g_client = GiantClient.new( :adapter => :typhoeus, :host => 'www.google.com' )
    g_client.get(:path => '/')

    # the next on port 8080
    # 2 ways to do this:
    # way 1
    g_client.port = 8080
    g_client.get(:path => '/')
    # way 2
    g_client.get(:path => '/', :port => 8080)

######Timeouts
In GiantClient timeouts can be configured on initialization or request by request. 
If you just leave it alone, the default timeout is 30 seconds. This is roughly the average of the clients supported. 
Setting a timeout sets both the read timeout and the connect timeout.
*Setting a Timeout*
    # on configuration
    client = GiantClient.new( :adapter => :typhoeus, :timeout => 5 ) # five second timeout
    client.get '/'                                                   # will raise a GiantClient::TimeoutError if it takes longer than 5 seconds.

    # request specific timeout
    client = GiantClient.new :typhoeus           # five second timeout
    client.get '/', :timeout => 1                # will raise a GiantClient::TimeoutError if it takes longer than 1 second.

######Passing a string as the options will set path = to that string and all other options to their defaults
    client.get('/') # same as :path => '/'

######Passing a string and options will set path = to that string and all other options to those specified in the options
    client.get('/', { :query => "foo=bar" }) # same as :path => '/', :query => "foo=bar"

######The string argument takes precedence
    client.get('/', {:path => '/this/does/not/matter'}) # same as :path => '/'

######Passing more than 2 arguments or fewer than one argument will raise an ArgumentError
    client.get('I', 'skipped', 'the', 'README') # ArgumentError

*Note: this is true with initialize too*

####Testing

Testing is easier than ever if you use GiantClient. Just call `GiantClient.new :adapter => :mock` and GiantClient will stub out all your requests.
When the adapter is set to `:mock` GiantClient stores all of your requests on a stack: `client.requests`. This is also true for responses.
`last_request` is shorthand (or longhand, actually) for `requests[0]` Check it out.

    describe 'Mock Adapter' do
      let(:client){ GiantClient.new :host => 'example.com', :adapter => :mock }

      context 'super simple request' do
        before do
          client.get('/')
        end

        it 'should record the url' do
          client.last_request.url.should == 'http://example.com/'
        end
      end
      context 'request with all options set' do
        before do
          opts = {
            :ssl => true,
            :port => 9292,
            :path => '/hey/there',
            :query => { 'howya' => 'doing' },
            :headers => { 'Content-Type' => 'application/awesome' },
            :body => 'test body',
            :timeout => 27
          }
          client.get(opts)
        end

        it 'should record the (correct) url' do
          url = 'https://example.com:9292/hey/there?howya=doing'
          client.last_request.url.should == url
        end

        it 'should record the (correct) ssl' do
          client.last_request.ssl.should == true
        end
        it 'should record the (correct) port' do
          client.last_request.port.should == 9292
        end
        it 'should record the (correct) path' do
          client.last_request.path.should == '/hey/there'
        end
        it 'should record the (correct) query' do
          client.last_request.query.should == { 'howya' => 'doing' }
        end
        it 'should record the (correct) query_string' do
          client.last_request.querystring.should == 'howya=doing'
        end
        it 'should record the (correct) headers' do
          client.last_request.headers.should ==
                                { 'Content-Type' => 'application/awesome' }
        end
        it 'should record the (correct) body' do
          client.last_request.body.should == 'test body'
        end
        it 'should record the (correct) timeout' do
          client.last_request.timeout.should == 27
        end
      end
    end

Giant Client creates a response hash for the mock requests. By default it is this:

    {
      :status_code => 200,
      :headers     => {},
      :body        => nil
    }

You can manipulate the response to a specific request with the `respond_with` method, which merges in your settings:
    client.get('/').respond_with(:body => 'hey')
    client.last_response.should == {
                                     :status_code => 200,
                                     :headers     => {},
                                     :body        => 'hey'
                                   }
You can set arbitrary fields (although there usually isn't reason to)

    client.get('/').respond_with(:headers => {}:body => 'hey')
    client.last_response.should == {
                                     :status_code => 200,
                                     :headers     => {},
                                     :body        => 'hey'
                                   }

As many as you want

    client.get('/').respond_with(:headers => {
                                                'Content-Type' => 'application/json',
                                                'X-Powered-By' => 'Internet'
                                             },
                                             :body => 'hey',
                                             :foo  => 'bar'
                                )
    client.last_response.should == {
                                     :status_code => 200,
                                     :headers     => {
                                                        'Content-Type' => 'application/json',
                                                        'X-Powered-By' => 'Internet'
                                                     },
                                     :body        => 'hey',
                                     :foo        => 'bar'
                                   }


*For tests with multiple requests / responses, visit spec/examples/mock_adapter_spec.rb*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
