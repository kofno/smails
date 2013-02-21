require 'spec_helper'

describe MailReceiver do

  let(:test_message) { '<Example email content>' }
  let(:message_processor) { double(:message_processor) }
  let(:mail_receiver) {
    MailReceiver.new
  }

  before :each do
    mail_receiver.message_processor = message_processor
    message_processor.should_receive(:process).with(test_message)
  end

  it 'sends newly received messages to the message processor' do
    mail_receiver.on_message content: test_message
  end
end
