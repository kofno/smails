class CreateEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages do |t|
      t.text :to
      t.text :cc
      t.text :bcc
      t.text :from
      t.text :subject
      t.text :body
      t.text :raw_source

      t.timestamps
    end
  end
end
