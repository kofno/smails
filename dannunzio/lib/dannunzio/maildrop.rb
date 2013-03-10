require 'dannunzio/db'
require 'bcrypt'

module Dannunzio

  class Maildrop < Sequel::Model
    include BCrypt

    one_to_one :lock

    def authenticate! password
      unless self.password == password
        raise 'invalid credentials'
      end
    end

    def lock!
      raise 'unable to lock maildrop' unless self.lock.nil?
      self.lock = Lock.new
    end

    def password=(password)
      self[:password] = Password.create password
    end

    def password
      Password.new self[:password]
    end

  end

end
