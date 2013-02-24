require 'spec_helper'

describe OutgoingMessageProcessor do

  let(:publisher) { double(:publisher) }
  let(:processor) { OutgoingMessageProcessor.new publisher: publisher }

  it 'publishes outgoing messages' do
    message = double(:message)
    message.should_receive(:to_s).and_return('<Email Message>')
    publisher.should_receive(:publish).with('<Email Message>')

    processor.send [message]
  end

end
