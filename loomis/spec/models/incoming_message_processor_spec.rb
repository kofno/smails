require 'spec_helper'

describe IncomingMessageProcessor do

  let(:test_source)              { :'test source' }
  let(:email_message)            { double(:email_message) }
  let(:email_creator)            { double(:email_creator) }

  let(:processor) {
    IncomingMessageProcessor.new email_creator: email_creator
  }

  before :each do
    email_creator.
      should_receive(:create!).
      and_return email_message
  end

  it 'processes the message' do
    email_message.should_receive(:associate_with_lists)
    email_message.should_receive(:distribute)

    processor.process test_source
  end
end
