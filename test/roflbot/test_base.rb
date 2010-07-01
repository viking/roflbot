require File.dirname(__FILE__) + "/../helper"

module Roflbot
  class TestBase < Test::Unit::TestCase
    def setup
      super
      @options = {
        "accounts" => {
          "AIM" => { "username" => "roflbot", "password" => "password" },
          "Twitter" => { "token" => "abcdef", "secret" => "123456" }
        }
      }
    end

    def test_new
      Net::TOC.expects(:new).with("roflbot", "password").returns(@client)
      Twitter::OAuth.expects(:new).with(Base::TWITTER[:token], Base::TWITTER[:secret]).returns(@oauth)
      @oauth.expects(:authorize_from_access).with("abcdef", "123456")
      Twitter::Base.expects(:new).with(@oauth).returns(@twitter)
      roflbot = Base.new(@options)
    end

    def test_start
      roflbot = Base.new(@options)
      @client.expects(:connect)
      roflbot.start
    end

    def test_wait
      roflbot = Base.new(@options)
      @client.expects(:wait)
      roflbot.wait
    end

    def test_stop
      roflbot = Base.new(@options)
      @client.expects(:disconnect)
      roflbot.stop
    end

    def test_responds_to_aim_with_string
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      @buddy.expects(:send_im).with("oh hai")
      receive_im("hey")
    end

    def test_responds_to_twitter_with_string
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      seq = sequence("foo")
      @twitter.expects(:mentions).returns([fake_tweet("hey", 12345)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai").in_sequence(seq)
      roflbot.respond_via_twitter

      seq = sequence("bar")
      @twitter.expects(:mentions).with(:since_id => 12345).returns([fake_tweet("hey", 23456)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai").in_sequence(seq)
      roflbot.respond_via_twitter
    end

    def test_saves_since_id
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      seq = sequence("foo")
      @twitter.expects(:mentions).returns([fake_tweet("hey", 12345)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai").in_sequence(seq)
      roflbot.respond_via_twitter

      assert_equal 12345, roflbot.options['accounts']['Twitter']['since_id']
    end

    def test_uses_saved_since_id
      @options['accounts']['Twitter']['since_id'] = 1337
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      seq = sequence("foo")
      @twitter.expects(:mentions).with(:since_id => 1337).returns([fake_tweet("hey", 12345)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai").in_sequence(seq)
      roflbot.respond_via_twitter
    end

    def test_responds_to_aim_with_block
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds { "omg wtf" }

      @buddy.expects(:send_im).with("omg wtf")
      receive_im("hey")
    end
  end
end
