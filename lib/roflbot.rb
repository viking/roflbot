require 'forwardable'
require 'rubygems'
require 'net/toc'

class Roflbot
  class Expectation
    attr_reader :response

    def initialize(regexp)
      @regexp = regexp
    end

    def matches?(message)
      @regexp =~ message
    end

    def responds(message)
      @response = message
    end
  end

  extend Forwardable
  def initialize(username, password)
    @username = username
    @password = password
    @expectations = []

    @client = Net::TOC.new(@username, @password)
    @client.on_im { |m, b, a| on_im(m, b, a) }
  end

  def_delegator :@client, :connect
  def_delegator :@client, :wait

  def expects(regexp)
    exp = Expectation.new(regexp)
    @expectations << exp
    exp
  end

  def on_im(message, buddy, auto_response)
    @expectations.each do |expectation|
      next  if !expectation.matches?(message)
      buddy.send_im(expectation.response)
      break
    end
  end
end
