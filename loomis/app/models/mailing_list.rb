class MailingList < ActiveRecord::Base
  attr_accessible :email_address, :name

  validates :email_address, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :name, length: { maximum: 255 }

  has_many :list_mails
  has_many :email_messages, through: :list_mails

  has_many :list_memberships
  has_many :members

  def self.filter_by_addresses email_addresses
    where email_address: email_addresses
  end

  def prepare_outgoing_message message
    message.to recipients
    message.sender email_address
    message
  end

  private

  def recipients
    memebers.map &:email_address
  end
end
