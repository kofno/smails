require 'torquebox-messaging'

class OutgoingMessageProcessor

  attr_reader :publisher

  def initialize args = {}
    @publisher = args.fetch :publisher, default_send_queue
  end

  def send messages
    messages.each do |message|
      publisher.publish message.to_s
    end
  end

  def default_send_queue
    TorqueBox::Messaging::Queue.new '/queues/mail_sender'
  end
end
