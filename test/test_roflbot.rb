require File.dirname(__FILE__) + "/helper"

class TestRoflbot < Test::Unit::TestCase
  def test_new
    Net::TOC.expects(:new).with("roflbot", "password").returns(@client)
    roflbot = Roflbot.new("roflbot", "password")
  end

  def test_connect
    roflbot = Roflbot.new("roflbot", "password")
    @client.expects(:connect)
    roflbot.connect
  end

  def test_wait
    roflbot = Roflbot.new("roflbot", "password")
    @client.expects(:wait)
    roflbot.wait
  end

  def test_responds_with_string
    roflbot = Roflbot.new("roflbot", "password")
    roflbot.expects(/^hey$/).responds("oh hai")

    @buddy.expects(:send_im).with("oh hai")
    receive_im("hey")
  end

  def test_responds_with_block
    roflbot = Roflbot.new("roflbot", "password")
    roflbot.expects(/^hey$/).responds { "omg wtf" }

    @buddy.expects(:send_im).with("omg wtf")
    receive_im("hey")
  end
end
