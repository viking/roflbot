require 'test/unit'
require 'rubygems'
require 'mocha'
require 'delegate'
require 'ruby-debug'
require 'tempfile'
require File.dirname(__FILE__) + "/../lib/roflbot"

class FakeClient < Mocha::Mock
  attr_reader :on_im_block
  def on_im(&block)
    @on_im_block = block
  end
end

class Test::Unit::TestCase
  def setup
    @client = FakeClient.new
    @buddy = stub("Buddy")
    Net::TOC.stubs(:new).returns(@client)

    @oauth = stub("OAuth", :authorize_from_access => [])
    @twitter = stub("Twitter", :mentions => [])
    Twitter::OAuth.stubs(:new).returns(@oauth)
    Twitter::Base.stubs(:new).returns(@twitter)
    @gvoice = stub("Gvoice", :smss => [])
    GvoiceRuby::Client.stubs(:new).returns(@gvoice)
  end

  def receive_im(message, auto = false)
    @client.on_im_block.call(message, @buddy, auto)
  end

  def fake_tweet(message, id)
    Hashie::Mash.new("user" => { "screen_name" => "dudeguy" }, "text" => "@roflbot #{message}", "id" => id)
  end

  def fake_sms(message)
    stub("SMS", {
      :text => message,
      :from => "+16158675309",
      :labels => %w{unread}
    })
  end

  def fixture_filename(name)
    File.dirname(__FILE__) + "/fixtures/#{name}"
  end

  def create_config(name)
    tmp = Tempfile.open("roflbot_config")
    file = File.open(fixture_filename(name), "r")
    tmp.write(file.read)
    file.close
    tmp.close
    tmp.path
  end
end
