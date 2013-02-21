require 'mail'

module Golpher

  class MessageProcessor

    attr_reader :success, :failure

    def initialize success_queue, failure_queue
      @success = success_queue
      @failure = failure_queue
    end

    def process message
      mail = Mail.new message
      success.publish message: mail.subject, content: mail.to_s
    rescue => e
      failure.publish message: e.message, content: message
    end
  end
end
