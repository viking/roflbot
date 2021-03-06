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

    def test_new_with_gvoice
      conf = stub("gvoice config")
      @options['accounts']['Google Voice'] = conf
      GvoiceRuby::Client.expects(:new).with(conf).returns(@gvoice)
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
      @twitter.expects(:update).with("@dudeguy oh hai", :in_reply_to_status_id => 12345).in_sequence(seq)
      roflbot.respond_via_twitter

      seq = sequence("bar")
      @twitter.expects(:mentions).with(:since_id => 12345).returns([fake_tweet("hey", 23456)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai", :in_reply_to_status_id => 23456).in_sequence(seq)
      roflbot.respond_via_twitter
    end

    def test_handles_twitter_exceptions
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      @twitter.expects(:mentions).raises(Twitter::TwitterError, 'foo')
      assert_nothing_raised { roflbot.respond_via_twitter }
    end

    def test_saves_since_id
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      seq = sequence("foo")
      @twitter.expects(:mentions).returns([fake_tweet("hey", 12345)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai", kind_of(Hash)).in_sequence(seq)
      roflbot.respond_via_twitter

      assert_equal 12345, roflbot.options['accounts']['Twitter']['since_id']
    end

    def test_uses_saved_since_id
      @options['accounts']['Twitter']['since_id'] = 1337
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds("oh hai")

      seq = sequence("foo")
      @twitter.expects(:mentions).with(:since_id => 1337).returns([fake_tweet("hey", 12345)]).in_sequence(seq)
      @twitter.expects(:update).with("@dudeguy oh hai", kind_of(Hash)).in_sequence(seq)
      roflbot.respond_via_twitter
    end

    def test_responds_to_aim_with_block
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds { "omg wtf" }

      @buddy.expects(:send_im).with("omg wtf")
      receive_im("hey")
    end

    def test_respond_via_sms_with_string
      conf = stub("gvoice config")
      @options['accounts']['Google Voice'] = conf
      roflbot = Base.new(@options)
      roflbot.expects(/^hey$/).responds { "omg wtf" }

      seq = sequence("foo")
      @gvoice.expects(:check).in_sequence(seq)
      @gvoice.expects(:any_unread?).returns(true).in_sequence(seq)
      @gvoice.expects(:smss).returns([fake_sms("hey")]).in_sequence(seq)
      @gvoice.expects(:send_sms).with({
        :phone_number => "+16158675309",
        :text => "omg wtf",
      }).in_sequence(seq)
      roflbot.respond_via_sms
    end
  end
end
