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
    end

    def self.implode!
      DB.drop_table :locks
      DB.drop_table :maildrops
    end

  end
end
