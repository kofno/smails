require 'dannunzio/db'
require 'bcrypt'

module Dannunzio

  class Maildrop < Sequel::Model
    include BCrypt

    def authenticated? password
      self.password == password
    end

    def password=(password)
      self[:password] = Password.create password
    end

    def password
      Password.new self[:password]
    end
  end

end
