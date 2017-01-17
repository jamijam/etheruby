require 'net/http'
require 'uri'
require 'multi_json'

module Etheruby

  class Client
    def self.uri=(_uri)
      @@uri = URI.parse(_uri)
    end
    def self.method_missing(sym)
      @@uri ||= URI.parse('http://localhost:8545/')
      ClientHolder.new(@@uri,sym)
    end
  end

  class ClientHolder
    def initialize(uri,sym)
      @uri = uri
      @sym = sym
    end
    def method_missing(sym, *data)
      body = { 'id' => '1', 'method' => "#{@sym}_#{sym}", 'params' => data }
      text_response = http_post_request(::MultiJson.dump(body))
      ::MultiJson.load(text_response)
    end
    def http_post_request(post_body)
      http = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.content_type = 'application/json'
      request.body = post_body
      http.request(request).body
    end
  end

end
