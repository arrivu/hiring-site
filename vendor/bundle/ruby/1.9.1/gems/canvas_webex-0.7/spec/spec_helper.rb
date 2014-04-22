require 'canvas_webex/service'
require 'canvas_webex/meeting'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'webmock/rspec'
require 'pry'

WebMock.disable_net_connect!


RSpec.configure do |config|
  # some (optional) config here
end

def fixture(file)
  File.new(File.join(File.expand_path("../fixtures", __FILE__), file + ".xml"))
end

def stub_call(fixture_name, status = 200, request_body = nil)
  stub = stub_request(:post, "https://instructure.webex.com/WBXService/XMLService")
  stub = stub.with(body: request_body) if request_body
  stub.to_return(status: status, body:fixture(fixture_name), headers:{
    :content_type => 'application/xml; charset=utf-8'})
end

class Object
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      public_send(*a, &b) if respond_to?(a.first)
    end
  end
end

class String
  def camelcase(first_letter = :upper)
      return self if self !~ /_/ && self =~ /[A-Z]+.*/
      split('_').map{|e| e.capitalize}.join
  end
end