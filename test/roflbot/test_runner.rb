require File.dirname(__FILE__) + "/../helper"

module Roflbot
  class TestRunner < Test::Unit::TestCase
    def test_runs_sentence_bot
      bot = mock("SentenceBot", :connect => nil, :wait => nil)
      SentenceBot.expects(:new).with("foo", "bar", { "foo" => "bar" }).returns(bot)
      Runner.new(%W{-u foo -p bar -c #{fixture_filename("bogus.yml")}})
    end
  end
end
