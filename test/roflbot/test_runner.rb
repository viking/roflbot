require File.dirname(__FILE__) + "/../helper"

module Roflbot
  class TestRunner < Test::Unit::TestCase
    def setup
      super
      @bot = stub("SentenceBot", :start => nil, :wait => nil, :options => {})
      SentenceBot.stubs(:new).returns(@bot)
    end

    def test_runs_sentence_bot
      @bot.expects(:start)
      @bot.expects(:wait)
      SentenceBot.expects(:new).with({ "foo" => "bar" }).returns(@bot)
      Runner.new(%W{-c #{create_config("bogus.yml")}})
    end

    def test_stop
      config = create_config("bogus.yml")
      runner = Runner.new(%W{-c #{config}})
      @bot.stubs(:options).returns({ "omg" => "whoa" })

      @bot.expects(:stop)
      runner.stop

      hash = YAML.load_file(config)
      assert_equal({ "omg" => "whoa" }, hash)
    end
  end
end
