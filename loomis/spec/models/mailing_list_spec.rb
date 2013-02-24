require 'spec_helper'

describe MailingList do

  let(:mailing_list) { MailingList.new email_address: 'list1@smails.com' }

  it 'prepares a message to be sent to its members' do
    recipients = ['foo@bar.com']
    mailing_list.should_receive(:recipients).and_return recipients
    message = double(:message)
    message.should_receive(:to).with(recipients)
    message.should_receive(:sender).with(mailing_list.email_address)

    mailing_list.prepare_outgoing_message(message)
  end
end
