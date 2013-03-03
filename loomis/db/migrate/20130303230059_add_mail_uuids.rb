class AddMailUuids < ActiveRecord::Migration
  def up
    add_column :email_messages, :uuid, :string
  end

  def down
    remove_column :email_messages, :uuid
  end
end
