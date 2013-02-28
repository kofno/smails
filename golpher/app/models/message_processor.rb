require 'mail'

class MessageProcessor

  attr_reader :success, :failure

  def initialize args
    @success = args[:success_handler]
    @failure = args[:failure_handler]
  end

  def process message
    mail = parse_message message
    queue_incoming mail
  rescue => e
    queue_failure message: e.message, content: message
  end

  private

  def parse_message message
    Mail.new message
  end

  def queue_incoming mail
    success.publish message: mail.subject, content: mail.to_s
  end

  def queue_failure args
    failure.publish message: args[:message], content: args[:content]
  end
end
