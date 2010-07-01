module Roflbot
  class Runner
    def initialize(argv = ARGV)
      @config = nil
      OptionParser.new do |opts|
        opts.on("-c", "--config FILENAME") { |c| @config = c }
      end.parse!(argv)

      @bot = SentenceBot.new(YAML.load_file(@config))
      Signal.trap("INT") { stop }
      @bot.start
      @bot.wait
    end

    def stop
      @bot.stop
      File.open(@config, "w") { |f| f.write(@bot.options.to_yaml) }
    end
  end
end
