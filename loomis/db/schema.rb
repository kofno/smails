# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130217204318) do

  create_table "email_messages", :force => true do |t|
    t.text     "to"
    t.text     "cc"
    t.text     "bcc"
    t.text     "from"
    t.text     "subject"
    t.text     "body"
    t.text     "raw_source"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "list_mails", :force => true do |t|
    t.integer  "mailing_list_id"
    t.integer  "email_message_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "list_mails", ["mailing_list_id", "email_message_id"], :name => "index_list_mails_on_mailing_list_id_and_email_message_id", :unique => true

  create_table "mailing_lists", :force => true do |t|
    t.string   "email_address", :null => false
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "mailing_lists", ["email_address"], :name => "index_mailing_lists_on_email_address", :unique => true

end
