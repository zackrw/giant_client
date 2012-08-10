require File.expand_path( '../spec_helper', __FILE__ )

describe 'GiantClient' do

  describe 'NetHttpAdapter' do

    context 'GET requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => GiantClient::NetHttpAdapter ) }

      it 'should perform a simple GET request' do
        stub = stub_request(:get, 'example.com')
        client.get( :path => '/' )
        stub.should have_been_requested
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
        expect{ client.get( :path => '/', :body => 'hey yo' ) }.to raise_error( GiantClient::NotImplementedError )
      end

      context 'ssl' do
        let(:client) { GiantClient.new( :host => 'example.com', :ssl => true, :adapter => GiantClient::NetHttpAdapter ) }

        it 'should perform a simple get request' do
          stub = stub_request(:get, 'https://example.com')
          client.get( :path => '/' )
          stub.should have_been_requested
        end
      end

      context 'custom port' do
        let(:client) { GiantClient.new( :host => 'example.com', :ssl => true, :port => 8080, :adapter => GiantClient::NetHttpAdapter ) }

        it 'should perform a simple GET request' do
          stub = stub_request(:get, 'https://example.com:8080')
          client.get( :path => '/' )
          stub.should have_been_requested
        end
      end
    end

    context 'POST requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => GiantClient::NetHttpAdapter ) }

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
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => GiantClient::NetHttpAdapter ) }

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
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => GiantClient::NetHttpAdapter ) }

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

      it 'can have a body for delete as well' do
        stub = stub_request(:delete, 'example.com').with( :body => 'woohoo' )
        client.delete( :path => '/', :body => 'woohoo' )
        stub.should have_been_requested
      end
    end

    context 'HEAD requests' do
      let(:client) { GiantClient.new( :host => 'example.com', :adapter => GiantClient::NetHttpAdapter ) }

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

      it 'can have a body for head as well' do
        stub = stub_request(:head, 'example.com').with( :body => 'woohoo' )
        client.head( :path => '/', :body => 'woohoo' )
        stub.should have_been_requested
      end
    end

  end

end
