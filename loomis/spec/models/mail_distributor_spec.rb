require 'spec_helper'

describe MailDistributor do

  let(:test_message) { :'test message' }
  let(:sender)       { double :sender }
  let(:distributor) {
    MailDistributor.new sender: sender
  }

  it 'publishes the mail' do
    sender.should_receive(:publish).with test_message
    distributor.distribute test_message
  end
end
