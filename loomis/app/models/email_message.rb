class EmailMessage < ActiveRecord::Base
  attr_accessible :raw_source

  serialize :to
  serialize :cc
  serialize :bcc

  has_many :list_mails
  has_many :mailing_lists, through: :list_mails

  def raw_source= email_source
    write_attribute :raw_source, email_source
    populate_email_fields
  end

  def associate_with_lists
    recipient_mailing_list_matches.each do |list|
      mailing_lists << list
    end
  end

  private

  def recipient_mailing_list_matches
    MailingList.filter_by_addresses recipients
  end

  def recipients
    to + cc + bcc
  end

  def parsed_email
    @parsed_email || Mail.new(raw_source)
  end

  def populate_email_fields
    self.to      ||= parsed_email.to_addrs
    self.cc      ||= parsed_email.cc_addrs
    self.bcc     ||= parsed_email.bcc_addrs
    self.from    ||= parsed_email.from_addrs
    self.subject ||= parsed_email.subject
  end
end
