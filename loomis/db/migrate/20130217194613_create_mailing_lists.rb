class CreateMailingLists < ActiveRecord::Migration
  def change
    create_table :mailing_lists do |t|
      t.string :email_address, null: false
      t.string :name

      t.timestamps
    end

    add_index :mailing_lists, :email_address, unique: true
  end
end
