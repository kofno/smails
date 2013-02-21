require 'spec_helper'

describe IncomingMessageProcessor do

  let(:test_source)              { :'test source' }
  let(:email_message)            { double(:email_message) }

  let(:email_creator)            { double(:email_creator) }
  let(:list_association_manager) { double(:list_association_manager) }
  let(:mail_distributor)         { double(:mail_distributor) }

  let(:processor) {
    IncomingMessageProcessor.new(
      creator: email_creator,
      association_manager: list_association_manager,
      distributor: mail_distributor)
  }

  before :each do
    email_creator.
      should_receive(:create!).
      and_return email_message

    list_association_manager.
      should_receive(:associate_with_lists).
      with email_message
    
    mail_distributor.
      should_receive(:distribute).
      with email_message
  end

  it 'processes the message' do
    processor.process test_source
  end
end
