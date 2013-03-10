module Dannunzio

  class Schema

    DB = Store::DB

    def self.load
      DB.create_table? :maildrops do
        primary_key :id
        String      :username, unique: true
        String      :password
      end
    end

  end
end
