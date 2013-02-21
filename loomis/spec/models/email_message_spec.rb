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
  let(:expected_recipients) { expected_to + expected_cc + expected_bcc }
  let(:expected_subj)       { 'This is only a test' }

  it 'populates address fields from raw source' do
    expect(email.to).to   eq(expected_to)
    expect(email.cc).to   eq(expected_cc)
    expect(email.bcc).to  eq(expected_bcc)
    expect(email.from).to eq(expected_from)

    expect(email.recipients).to eq(expected_recipients)
  end

  it 'populates the subject from the raw source' do
    expect(email.subject).to eq(expected_subj)
  end

end
