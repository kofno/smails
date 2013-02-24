class ListMembership < ActiveRecord::Base
  attr_accessible :mailing_list_id, :member_id

  validates :member_id, presence: true, uniqueness: { scope: :mailing_list_id }
  validates :mailing_list_id, presence: true
end
