require File.dirname(__FILE__) + "/../helper"

module Roflbot
  class TestBase < Test::Unit::TestCase
    def test_new
      Net::TOC.expects(:new).with("roflbot", "password").returns(@client)
      roflbot = Base.new("roflbot", "password")
    end

    def test_connect
      roflbot = Base.new("roflbot", "password")
      @client.expects(:connect)
      roflbot.connect
    end

    def test_wait
      roflbot = Base.new("roflbot", "password")
      @client.expects(:wait)
      roflbot.wait
    end

    def test_disconnect
      roflbot = Base.new("roflbot", "password")
      @client.expects(:disconnect)
      roflbot.disconnect
    end

    def test_responds_with_string
      roflbot = Base.new("roflbot", "password")
      roflbot.expects(/^hey$/).responds("oh hai")

      @buddy.expects(:send_im).with("oh hai")
      receive_im("hey")
    end

    def test_responds_with_block
      roflbot = Base.new("roflbot", "password")
      roflbot.expects(/^hey$/).responds { "omg wtf" }

      @buddy.expects(:send_im).with("omg wtf")
      receive_im("hey")
    end
  end
end
