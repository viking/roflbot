Treetop.load(File.dirname(__FILE__) + "/sentence.tt")

module Roflbot
  class SentenceBot < Base
    def initialize(*args)
      super
      parser = SentenceParser.new
      @sentences = []
      @options.delete("sentences").each do |sentence|
        node = parser.parse(sentence)
        @sentences << node
      end
      self.expects(/^.*$/).responds { generated_message }
    end

    def generated_message
      node = @sentences[rand(@sentences.length)]
      node.to_s(@options)
    end
  end
end
