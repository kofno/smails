class MailingList < ActiveRecord::Base
  attr_accessible :email_address, :name

  validates :email_address, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :name, length: { maximum: 255 }

  has_many :list_mails
  has_many :email_messages, through: :list_mails

  def self.associate_with_lists email
    lists = recipient_lists email.recipients
    lists.each do |list|
      email.mailing_lists << list
    end
  end

  def self.recipient_lists recipients
    where email_address: recipients
  end

end
