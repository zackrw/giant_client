require File.expand_path( '../spec_helper', __FILE__ )

describe 'GiantClient' do

  shared_examples "an adapter" do

    context 'GET requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => adapter ) }

      it 'should perform a simple GET request' do
        stub = stub_request(:get, 'example.com')
        client.get( :path => '/' )
        stub.should have_been_requested
      end

      it 'should treat a string argument as a path' do
        stub = stub_request(:get, 'example.com')
        client.get( '/' )
        stub.should have_been_requested
      end

      it 'should respond with 200' do
        stub = stub_request(:get, 'example.com')
                      .to_return(:status => [200, 'OK'])
        client.get( :path => '/' ).status_code.should == 200
      end

      it 'should respond with a success header' do
        stub = stub_request(:get, 'example.com')
                       .to_return(:headers => {'Success' => 'true'})
        client.get( :path => '/' ).headers.should == {'Success' => 'true'}
      end

      it 'should respond with a multiple headers' do
        stub = stub_request(:get, 'example.com')
                       .to_return(:headers =>
                                  {'Success' => 'true', 'doodle' => 'kaboodle'})
        client.get( :path => '/' ).headers.should ==
                                      {'Success' => 'true', 'Doodle' => 'kaboodle'}
      end

      it 'should respond with a header and status, and should capitalize status' do
        stub = stub_request(:get, 'example.com')
                       .to_return(:status => 1700, :headers => {'success' => 'true'})
        client.get( :path => '/' ).headers.should == {'Success' => 'true'}
        client.get( :path => '/' ).status_code.should == 1700
      end

      it 'should respond with a body' do
        stub = stub_request(:get, 'example.com')
                       .to_return(:body => 'Chucky Cheese')
        client.get( :path => '/' ).body.should == 'Chucky Cheese'
      end

      it 'should pass on the port' do
        stub = stub_request(:get, 'example.com:8080')
        client.get( :path => '/', :port => '8080' )
        stub.should have_been_requested
      end

      it 'should pass on the request headers' do
        stub = stub_request(:get, 'example.com').with( :headers => { 'Content-Type' => 'text/special' } )
        client.get( :path => '/', :headers => { 'Content-Type' => 'text/special' } )
        stub.should have_been_requested
      end

      it 'should pass on the request params' do
        stub = stub_request(:get, 'example.com').with( :query => { 'a' => 'b' } )
        client.get( :path => '/', :query => { 'a' => 'b' } )
        stub.should have_been_requested
      end

      it 'should allow a query in the url path' do
        stub = stub_request(:get, 'example.com').with( :query => { 'z' => 'me' } )
        client.get( :path => '/?z=me' )
        stub.should have_been_requested
      end

      it 'should raise an error if there is a request body' do
        stub = stub_request(:get, 'example.com').with( :body => 'hey yo' )
        expect{ client.get( :path => '/', :body => 'hey yo' ) }.to raise_error( GiantClient::Error::NotImplemented )
      end

      context 'timing out' do
        let(:client) { GiantClient.new( :host => 'example.com', :adapter => adapter, :timeout => 1 ) }

        it 'should raise a timeout error if there is a timeout' do
          stub = stub_request(:get, 'example.com').to_timeout
          expect{ client.get( :path => '/' ) }.to raise_error( GiantClient::Error::Timeout )
        end
      end

      context 'ssl' do
        let(:client) { GiantClient.new( :host => 'example.com', :ssl => true, :adapter => adapter ) }

        it 'should perform a simple get request' do
          stub = stub_request(:get, 'https://example.com')
          client.get( :path => '/' )
          stub.should have_been_requested
        end
      end

      context 'custom port' do
        let(:client) { GiantClient.new( :host => 'example.com', :ssl => true, :port => 8080, :adapter => adapter ) }

        it 'should perform a simple GET request' do
          stub = stub_request(:get, 'https://example.com:8080')
          client.get( :path => '/' )
          stub.should have_been_requested
        end
      end
    end

    context 'POST requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => adapter ) }

      it 'should perform a simple POST request' do
        stub = stub_request(:post, 'example.com')
        client.post( :path => '/' )
        stub.should have_been_requested
      end

      it 'should post the body as well' do
        stub = stub_request(:post, 'example.com').with( :body => 'woohoo' )
        client.post( :path => '/', :body => 'woohoo' )
        stub.should have_been_requested
      end
    end

    context 'PUT requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => adapter ) }

      it 'should perform a simple PUT request' do
        stub = stub_request(:put, 'example.com')
        client.put( :path => '/' )
        stub.should have_been_requested
      end

      it 'should perform a PUT request to a specific path' do
        stub = stub_request(:put, 'example.com/heyyy')
        client.put( :path => '/heyyy' )
        stub.should have_been_requested
      end

      it 'should put the body as well' do
        stub = stub_request(:put, 'example.com').with( :body => 'woohoo' )
        client.put( :path => '/', :body => 'woohoo' )
        stub.should have_been_requested
      end
    end

    context 'DELETE requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => adapter ) }

      it 'should perform a simple DELETE request' do
        stub = stub_request(:delete, 'example.com')
        client.delete( :path => '/' )
        stub.should have_been_requested
      end

      it 'should perform a DELETE request to a specific path' do
        stub = stub_request(:delete, 'example.com/heyyy/how/ya/doin')
        client.delete( :path => '/heyyy/how/ya/doin' )
        stub.should have_been_requested
      end

      it 'should raise an error if there is a request body' do
        stub = stub_request(:delete, 'example.com').with( :body => 'woohoo' )
        expect{ client.delete( :path => '/', :body => 'woohoo' ) }.to raise_error( GiantClient::Error::NotImplemented )
      end
    end

    context 'HEAD requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => adapter ) }

      it 'should perform a simple HEAD request' do
        stub = stub_request(:head, 'example.com')
        client.head( :path => '/' )
        stub.should have_been_requested
      end

      it 'should perform a HEAD request to a specific path' do
        stub = stub_request(:head, 'example.com/heyyy/how/ya/doin')
        client.head( :path => '/heyyy/how/ya/doin' )
        stub.should have_been_requested
      end

      it 'should raise an error if there is a request body' do
        stub = stub_request(:head, 'example.com').with( :body => 'woohoo' )
        expect{ client.head( :path => '/', :body => 'woohoo' ) }.to raise_error( GiantClient::Error::NotImplemented )
      end
    end
  end

  describe 'NetHttpAdapter' do
    it_behaves_like 'an adapter' do
      let(:adapter){ :net_http }
    end
  end

  describe 'PatronAdapter' do
    it_behaves_like 'an adapter' do
      let(:adapter){ :patron }
    end
  end

  describe 'Curb' do
    it_behaves_like 'an adapter' do
      let(:adapter){ :curb }
    end
  end

  describe 'Excon' do
    it_behaves_like 'an adapter' do
      let(:adapter){ :excon }
    end
  end

  describe 'Typhoeus' do
    it_behaves_like 'an adapter' do
      let(:adapter){ :typhoeus }
    end
  end


  describe 'AbstractAdapter' do

    let(:adapter){ GiantClient::AbstractAdapter.new }

    describe '#normalize_header' do

      it 'should not touch a header that is already title case' do
        adapter.normalize_header('Content-Type').should == 'Content-Type'
      end

      it 'should convert a header to title case' do
        adapter.normalize_header('content-type').should == 'Content-Type'
      end

      it 'should only capitalize the first letter of words' do
        adapter.normalize_header('CONTENT-type').should == 'Content-Type'
      end

      it 'should work for one word' do
        adapter.normalize_header('acCEPTS').should == 'Accepts'
      end

      it 'should downcase appropriately' do
        adapter.normalize_header('CONTENT-LENGTH').should == 'Content-Length'
      end

      it 'should handle a another, similar situation' do
        adapter.normalize_header('x-Forwarded-for').should == 'X-Forwarded-For'
      end
    end

    describe '#encode_query' do

      it 'should return empty string from empty hash' do
        adapter.encode_query({}).should == ''
      end

      it 'should prefix string argument with ?' do
        adapter.encode_query('parsnips').should == '?parsnips'
      end

      it 'should correctly convert hash to query string with ?' do
        adapter.encode_query({ :tra => "lala", :ha => "za"} )
                                      .should == '?tra=lala&ha=za'
      end
    end

    describe '#url_from_opts' do
      let(:opts){{
        :path => '/', :host => 'example.com',
        :ssl => false, :port => 80,
        :query => {}, :body => '',
        :headers => {}
      }}

      it 'should not have the correct url' do
        adapter.url_from_opts(opts).should == "http://example.com/"
      end

      it 'should use ssl if we tell it to' do
        opts[:ssl] = true
        adapter.url_from_opts(opts)[0...8].should == "https://"
      end

      it 'should work with a custom port' do
        opts[:ssl] = true
        opts[:port] = 8080
        adapter.url_from_opts(opts)[19...24].should == ":8080"
      end

    end
  end

end
