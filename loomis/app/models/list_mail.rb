class ListMail < ActiveRecord::Base
  attr_accessible :email_message_id, :mailing_list_id

  validates :email_message_id, presence: true, uniqueness: { scope: :mailing_list_id }
  validates :mailing_list_id,  presence: true

  belongs_to :mailing_list
  belongs_to :email_message

end
