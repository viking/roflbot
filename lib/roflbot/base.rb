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
    TWITTER = { :token => "7rfuoIhSGN7OQVvDLzJrcg", :secret => "I2o4SmRWVV4Yo7XhGgLrKGJq1KgpC8VrluyA9LLuH0" }

    attr_reader :options
    def initialize(options = {})
      @options = options
      @expectations = []
      accounts = @options["accounts"]

      @aim = Net::TOC.new(*accounts["AIM"].values_at("username", "password"))
      @aim.on_im { |m, b, a| on_im(m, b, a) }

      oauth = Twitter::OAuth.new(TWITTER[:token], TWITTER[:secret])
      oauth.authorize_from_access(*accounts["Twitter"].values_at("token", "secret"))
      @twitter = Twitter::Base.new(oauth)
      @since_id = accounts['Twitter']['since_id']
    end

    def_delegator :@aim, :disconnect

    def start
      @aim.connect
      @thread = Thread.new { loop { respond_via_twitter; sleep 60 } }
    end

    def wait
      @aim.wait
    end

    def stop
      @aim.disconnect
      @thread.kill  if @thread
    end

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

    def respond_via_twitter
      begin
        mentions = @twitter.mentions(@since_id ? {:since_id => @since_id} : {})
      rescue StandardError
        mentions = []
      end
      if !mentions.empty?
        @since_id = mentions[-1].id
        @options['accounts']['Twitter']['since_id'] = @since_id
      end

      mentions.each do |tweet|
        @expectations.each do |expectation|
          # throw away beginning mention
          message = tweet.text.sub(/^@[^\s]+\s+/, "")

          next  if !expectation.matches?(message)

          status =
            case expectation.response
            when Proc
              "@#{tweet.user.screen_name} #{expectation.response.call}"
            when String
              "@#{tweet.user.screen_name} #{expectation.response}"
            end
          @twitter.update(status, :in_reply_to_status_id => tweet.id)
          break
        end
      end
    end
  end
end
