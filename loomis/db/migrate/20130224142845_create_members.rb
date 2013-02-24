class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :email_address

      t.timestamps
    end
  end
end
