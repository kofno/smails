module Dannunzio

  class Schema

    def self.load
      DB.create_table? :maildrops do
        primary_key :id
        String      :username, unique: true
        String      :password
      end

      DB.create_table? :locks do
        primary_key :id
        foreign_key :maildrop_id, :maildrops, unique: true
      end

      DB.create_table? :messages do
        primary_key :id
        foreign_key :maildrop_id
        clob :content
        Integer :octets
      end

      DB.create_table? :locked_messages do
        foreign_key :lock_id
        foreign_key :message_id
        primary_key [:lock_id, :message_id]
        boolean :marked_deleted, default: false
        Integer :index
      end
    end

    def self.implode!
      DB.drop_table :locked_messages
      DB.drop_table :locks
      DB.drop_table :messages
      DB.drop_table :maildrops
    end

  end
end
