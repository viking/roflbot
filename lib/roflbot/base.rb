module Roflbot
  class Base
    class Expectation
      attr_reader :response

      def initialize(regexp)
        @regexp = regexp
      end

      def matches?(message)
        @regexp =~ message
      end

      def responds(message = nil, &block)
        if block_given?
          @response = block
        else
          @response = message
        end
      end
    end

    extend Forwardable
    def initialize(username, password, options = {})
      @username = username
      @password = password
      @options = options
      @expectations = []

      @client = Net::TOC.new(@username, @password)
      @client.on_im { |m, b, a| on_im(m, b, a) }
    end

    def_delegator :@client, :connect
    def_delegator :@client, :disconnect
    def_delegator :@client, :wait

    def expects(regexp)
      exp = Expectation.new(regexp)
      @expectations << exp
      exp
    end

    def on_im(message, buddy, auto_response)
      @expectations.each do |expectation|
        next  if !expectation.matches?(message)
        case expectation.response
        when Proc
          buddy.send_im(expectation.response.call)
        when String
          buddy.send_im(expectation.response)
        end
        break
      end
    end
  end
end
