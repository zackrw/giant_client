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
        expect{ client.get( :path => '/', :body => 'hey yo' ) }.to raise_error( GiantClient::NotImplementedError )
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
        expect{ client.delete( :path => '/', :body => 'woohoo' ) }.to raise_error( GiantClient::NotImplementedError )
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
        expect{ client.head( :path => '/', :body => 'woohoo' ) }.to raise_error( GiantClient::NotImplementedError )
      end
    end
  end

  describe 'NetHttpAdapter' do
    it_behaves_like 'an adapter' do
      let(:adapter){ GiantClient::NetHttpAdapter }
    end
  end

  describe 'PatronAdapter' do
    it_behaves_like 'an adapter' do
      let(:adapter){ GiantClient::PatronAdapter }
    end
  end

  describe 'Curb' do
    it_behaves_like 'an adapter' do
      let(:adapter){ GiantClient::CurbAdapter }
    end
  end

  describe 'Excon' do
    it_behaves_like 'an adapter' do
      let(:adapter){ GiantClient::ExconAdapter }
    end
  end

  describe 'Typhoeus' do
    it_behaves_like 'an adapter' do
      let(:adapter){ GiantClient::TyphoeusAdapter }
    end
  end

end
