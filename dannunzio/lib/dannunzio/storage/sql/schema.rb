require_relative 'connection'

module Dannunzio
  module SQL

    class Schema
      include Connection

      def self.load
        new.load_all
      end

      def load_all
        load_maildrops
        load_locks
      end

      def load_maildrops
        db.create_table :maildrops do
          String :identifier, primary_key: true
          String :username, null: false, unique: true
          String :password, null: false
        end
      end

      def load_locks
        db.create_table :locks do
          primary_key :id
          String :maildrop_id, null: false, unique: true
        end
      end

    end
  end
end
