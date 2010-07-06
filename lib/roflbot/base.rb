module Roflbot
  class Base
    class Expectation
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

      def response
        case @response
        when String
          @response
        when Proc
          @response.call
        end
      end
    end

    extend Forwardable
    TWITTER = { :token => "7rfuoIhSGN7OQVvDLzJrcg", :secret => "I2o4SmRWVV4Yo7XhGgLrKGJq1KgpC8VrluyA9LLuH0" }

    attr_reader :options
    def initialize(options = {})
      @options = options
      @expectations = []
      @threads = []
      accounts = @options["accounts"]

      @aim = Net::TOC.new(*accounts["AIM"].values_at("username", "password"))
      @aim.on_im { |m, b, a| on_im(m, b, a) }

      if accounts['Twitter']
        oauth = Twitter::OAuth.new(TWITTER[:token], TWITTER[:secret])
        oauth.authorize_from_access(*accounts["Twitter"].values_at("token", "secret"))
        @twitter = Twitter::Base.new(oauth)
        @since_id = accounts['Twitter']['since_id']
      end

      if accounts['Google Voice']
        @gvoice = GvoiceRuby::Client.new(accounts['Google Voice'])
      end
    end

    def start
      @aim.connect
      if @twitter
        @threads << Thread.new { loop { respond_via_twitter; sleep 60 } }
      end
      if @gvoice
        @threads << Thread.new { loop { respond_via_sms; sleep 60 } }
      end
    end

    def wait
      @aim.wait
    end

    def stop
      @aim.disconnect
      @threads.each { |t| t.kill }
    end

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

          @twitter.update("@#{tweet.user.screen_name} #{expectation.response}", :in_reply_to_status_id => tweet.id)
          break
        end
      end
    end

    def respond_via_sms
      @gvoice.check
      return  if !@gvoice.any_unread?

      @gvoice.smss.each do |sms|
        next  if !sms.labels.include?("unread")
        @expectations.each do |expectation|
          next  if !expectation.matches?(sms.text)
          @gvoice.send_sms(:phone_number => sms.from, :text => expectation.response)
        end
      end
    end
  end
end
