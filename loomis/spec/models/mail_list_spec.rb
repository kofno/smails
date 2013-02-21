require 'spec_helper'

describe MailingList do

  let(:expected_associations) { ['list1@somewhere.com', 'list2@somewhere.com'] }
  let(:test_message) {
    double(:test_message,
           recipients: expected_associations + ['no-one@nowhere.com'],
           mailing_lists: double(:mailing_lists))
  }

  it 'associates an email with mailling lists' do
    MailingList.should_receive(:recipient_lists).and_return(expected_associations)
    expected_associations.each do |list|
      test_message.mailing_lists.should_receive(:<<).with list
    end

    MailingList.associate_with_lists test_message
  end

end
