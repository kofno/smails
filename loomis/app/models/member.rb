class Member < ActiveRecord::Base
  attr_accessible :email_address

  validates :email_address, presence: true, length: { maximum: 255 }
end
