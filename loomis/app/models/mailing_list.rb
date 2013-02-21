class MailingList < ActiveRecord::Base
  attr_accessible :email_address, :name

  validates :email_address, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :name, length: { maximum: 255 }

  has_many :list_mails
  has_many :email_messages, through: :list_mails

  def self.filter_by_addresses email_addresses
    where conditions: email_addresses
  end
end
