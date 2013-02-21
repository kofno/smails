class MailDistributor

  attr_reader :sender
  private     :sender

  def initialize args
    @sender = args.fetch(:sender, outgoing_queue)
  end

  def distribute message
    sender.publish message
  end

  private

  def outgoing_queue
    @default_queue ||= TorqueBox::Messaging::Queue.new '/queues/mail_sender'
  end
end
