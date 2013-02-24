require 'spec_helper'

describe EmailMessage do

  let(:email) {
    source = IO.read(File.expand_path('../../fixtures/emails/1', __FILE__))
    EmailMessage.new raw_source: source
  }

  let(:expected_to)         { ['foo@foo.com'] }
  let(:expected_cc)         { ['bar@foo.com'] }
  let(:expected_bcc)        { ['baz@foo.com'] }
  let(:expected_from)       { ['qux@foo.com'] }
  let(:expected_subj)       { 'This is only a test' }
  let(:expected_recipients) { expected_to + expected_cc + expected_bcc }

  it 'populates address fields from raw source' do
    expect(email.to).to   eq(expected_to)
    expect(email.cc).to   eq(expected_cc)
    expect(email.bcc).to  eq(expected_bcc)
    expect(email.from).to eq(expected_from)
  end

  it 'populates the subject from the raw source' do
    expect(email.subject).to eq(expected_subj)
  end

  it 'distributes the email to each mailing list' do
    messages = double(:outgoing_messages)
    email.should_receive(:outgoing_messages).and_return messages
    distributor = double(:distributor)
    distributor.should_receive(:send).with(messages)
    email.distributor = distributor

    email.distribute
  end

  it 'associates itself with mailing lists' do
    recipient_mailing_list_matches = expected_to + expected_cc
    
    email.should_receive(:recipient_mailing_list_matches).
      and_return recipient_mailing_list_matches

    recipient_mailing_list_matches.each do |match|
      email.mailing_lists.should_receive(:<<).with(match)
    end
    
    email.associate_with_lists
  end

end
