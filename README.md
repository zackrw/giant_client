##Giant Client

Giant Client is a ruby library which exposes a simple and uniform API for
using a variety of http clients. Advantages of Giant Client:
* Clean, easy-to-use, cruftless API
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

######Passing a string as the options will set path = to that string and all other options to their defaults
    client.get('/') # same as :path => '/'

######Passing a string and options will set path = to that string and all other options to those specified in the options
    client.get('/', { :query => "foo=bar" }) # same as :path => '/', :query => "foo=bar"

######The string argument takes precedence
    client.get('/', {:path => '/this/does/not/matter'}) # same as :path => '/'

######Passing more than 2 arguments or fewer than one argument will raise an ArgumentError
    client.get('I', 'skipped', 'the', 'README') # ArgumentError

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
