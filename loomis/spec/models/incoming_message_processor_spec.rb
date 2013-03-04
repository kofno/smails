require 'spec_helper'

describe IncomingMessageProcessor do

  let(:email_message) { double(:email_message) }
  let(:email_creator) { double(:email_creator) }
  let(:test_source)   {
    { raw_source: '<email source>', uuid: '<uuid>'}
  }

  let(:processor) {
    IncomingMessageProcessor.new email_creator: email_creator
  }

  it 'creates and distributes the email message' do
    email_creator.should_receive(:create!).and_return email_message
    email_message.should_receive(:associate_with_lists)
    email_message.should_receive(:distribute)

    processor.process test_source
  end
end
