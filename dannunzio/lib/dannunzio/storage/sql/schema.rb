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
      end

      def load_maildrops
        db.create_table :maildrops do
          String :identifier, primary_key: true
          String :username, null: false, unique: true
          String :password, null: false
        end
      end
    end
  end
end
