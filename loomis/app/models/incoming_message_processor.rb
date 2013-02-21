class IncomingMessageProcessor

  attr_reader :creator, :association_manager, :distributor
  private     :creator, :association_manager, :distributor

  def initialize args
    @creator             = args.fetch :creator, EmailMessage
    @association_manager = args.fetch :association_manager, MailingList
    @distributor         = args.fetch :distributor, MailDistributor
  end

  def process message
    email = save message
    associate_with_lists email
    distribute email
  end

  private

  def save message
    creator.create! raw_source: message
  end

  def associate_with_lists email
    association_manager.associate_with_lists email
  end

  def distribute email
    distributor.distribute email
  end
end
