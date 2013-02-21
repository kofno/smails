class CreateListMails < ActiveRecord::Migration
  def change
    create_table :list_mails do |t|
      t.integer :mailing_list_id,  null: true
      t.integer :email_message_id, null: true

      t.timestamps
    end

    add_index :list_mails, [:mailing_list_id, :email_message_id], unique: { case_sensitive: false }
  end
end
