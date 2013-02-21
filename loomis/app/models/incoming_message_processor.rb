class IncomingMessageProcessor

  attr_reader :creator, :distributor
  private     :creator, :distributor

  def initialize args
    @creator = args.fetch :email_creator, EmailMessage
  end

  def process message
    email = save message
    email.associate_with_lists
    email.distribute
  end

  private

  def save message
    creator.create! raw_source: message
  end

end
