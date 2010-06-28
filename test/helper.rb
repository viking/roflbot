require 'test/unit'
require 'rubygems'
require 'mocha'
require 'delegate'
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
  end

  def receive_im(message, auto = false)
    @client.on_im_block.call(message, @buddy, auto)
  end
end
