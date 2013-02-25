require 'logger'
require 'torquebox-messaging'

module TheFlyingWasp

  class MailSender < TorqueBox::Messaging::MessageProcessor

    attr_reader :logger

    def initialize
      @logger = Logger.new STDOUT
    end

    # This example sender just logs messages
    def on_message body
      logger.info body
    end

  end

end
