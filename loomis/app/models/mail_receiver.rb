require 'torquebox-messaging'

class MailReceiver < TorqueBox::Messaging::MessageProcessor

  attr_writer :message_processor

  def on_message body
    message_processor.process body[:content]
  end

  private

  def message_processor
    @message_processor ||= IncomingMessageProcessor.new
  end

end
