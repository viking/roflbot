require File.dirname(__FILE__) + "/../helper"

module Roflbot
  class TestSentenceBot < Test::Unit::TestCase
    def test_base_superclass
      assert_equal Base, SentenceBot.superclass
    end

    def test_responses
      bot = SentenceBot.new('dudeguy', 'password', {
        "sentences" => ["Hey (noun), (ending)"],
        "noun" => %w{dude guy},
        "ending" => ["sup?", "I love you."]
      })

      @buddy.expects(:send_im).times(20).with do |message|
        message =~ /^Hey (dude|guy), (sup\?|I love you.)$/
      end
      20.times { |_| receive_im("hey") }
    end
  end
end
