module Roflbot
  class Runner
    def initialize(argv = ARGV)
      username = nil
      password = nil
      options = {}
      OptionParser.new do |opts|
        opts.on("-u", "--username USERNAME") { |u| username = u }
        opts.on("-p", "--password PASSWORD") { |p| password = p }
        opts.on("-c", "--config FILENAME") { |c| options = YAML.load_file(c) }
      end.parse!(argv)

      bot = SentenceBot.new(username, password, options)
      bot.connect
      Signal.trap("INT") { bot.disconnect }
      bot.wait
    end
  end
end
