require File.expand_path( '../spec_helper', __FILE__ )

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

  context 'multiple requests' do
    before do
      opts1 = {
        :ssl => false,
        :port => 4000,
        :path => '/me/first/please.jsp',
        :query => { 'say' => 'what', 'who' => 'me' },
        :headers => { 'Content-Length' => 'infinity' },
        :body => 'I\'m a request',
        :timeout => 102
      }
      opts2 = {
        :ssl => true,
        :port => 9292,
        :path => '/hey/there',
        :query => { 'howya' => 'doing' },
        :headers => { 'Content-Type' => 'application/awesome' },
        :body => 'test body',
        :timeout => 27
      }
      client.get(opts1)
      client.get(opts2)
    end

    context 'general' do
      it 'should have stored two requests' do
        client.requests.length.should == 2
      end
    end

    context 'last request' do
      it 'should record the (correct) last url' do
        url = 'https://example.com:9292/hey/there?howya=doing'
        client.last_request.url.should == url
      end

      it 'should record the (correct) last ssl' do
        client.last_request.ssl.should == true
      end
      it 'should record the (correct) last port' do
        client.last_request.port.should == 9292
      end
      it 'should record the (correct) last path' do
        client.last_request.path.should == '/hey/there'
      end
      it 'should record the (correct) last query' do
        client.last_request.query.should == { 'howya' => 'doing' }
      end
      it 'should record the (correct) last query_string' do
        client.last_request.querystring.should == 'howya=doing'
      end
      it 'should record the (correct) last headers' do
        client.last_request.headers.should ==
                              { 'Content-Type' => 'application/awesome' }
      end
      it 'should record the (correct) last body' do
        client.last_request.body.should == 'test body'
      end
      it 'should record the (correct) last timeout' do
        client.last_request.timeout.should == 27
      end
    end

    context 'second to last request' do
      it 'should record the (correct) second to last url' do
        url = 'http://example.com:4000/me/first/please.jsp?say=what&who=me'
        client.requests[1].url.should == url
      end

      it 'should record the (correct) second to last ssl' do
        client.requests[1].ssl.should == false
      end
      it 'should record the (correct) second to last port' do
        client.requests[1].port.should == 4000
      end
      it 'should record the (correct) second to last path' do
        client.requests[1].path.should == '/me/first/please.jsp'
      end
      it 'should record the (correct) second to last query' do
        client.requests[1].query.should == { 'say' => 'what', 'who' => 'me' }
      end
      it 'should record the (correct) second to last query_string' do
        client.requests[1].querystring.should == 'say=what&who=me'
      end
      it 'should record the (correct) second to last headers' do
        client.requests[1].headers.should ==
                              { 'Content-Length' => 'infinity' }
      end
      it 'should record the (correct) second to last body' do
        client.requests[1].body.should == 'I\'m a request'
      end
      it 'should record the (correct) second to last timeout' do
        client.requests[1].timeout.should == 102
      end
    end
  end
end
