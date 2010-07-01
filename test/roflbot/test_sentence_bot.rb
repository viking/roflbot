require File.dirname(__FILE__) + "/../helper"

module Roflbot
  class TestSentenceBot < Test::Unit::TestCase
    def setup
      super
      @options = {
        "accounts" => {
          "AIM" => {"username" => 'dudeguy', "password" => 'password'},
          "Twitter" => { "token" => "abcdef", "secret" => "123456" }
        },
        "sentences" => ["Hey (noun), (ending)"],
        "noun" => %w{dude guy},
        "ending" => ["sup?", "I love you."]
      }
    end

    def test_base_superclass
      assert_equal Base, SentenceBot.superclass
    end

    def test_responses
      bot = SentenceBot.new(@options)

      @buddy.expects(:send_im).times(20).with do |message|
        message =~ /^Hey (dude|guy), (sup\?|I love you.)$/
      end
      20.times { |_| receive_im("hey") }
    end

    def test_parses_quotes
      @options["sentences"] = ["You're awesome (noun), (ending)"]
      bot = SentenceBot.new(@options)

      @buddy.expects(:send_im).times(20).with do |message|
        message =~ /^You're awesome (dude|guy), (sup\?|I love you.)$/
      end
      20.times { |_| receive_im("hey") }
    end
  end
end
