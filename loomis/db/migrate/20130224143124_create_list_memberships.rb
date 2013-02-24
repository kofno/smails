class CreateListMemberships < ActiveRecord::Migration
  def change
    create_table :list_memberships do |t|
      t.integer :member_id
      t.integer :mailing_list_id

      t.timestamps
    end

    add_index :list_memberships, [:member_id, :mailing_list_id], unique: true
  end
end
