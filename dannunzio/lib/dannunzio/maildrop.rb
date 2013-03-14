require 'dannunzio/db'
require 'bcrypt'

module Dannunzio

  class Maildrop < Sequel::Model
    include BCrypt
    include Sequel

    one_to_many :locks
    one_to_many :messages

    def self.find_by_username! username
      drop = find username: username
      raise 'invalid credentials' unless drop
      drop
    end

    def authenticate! password
      unless self.password == password
        raise 'invalid credentials'
      end
    end

    def acquire_lock!
      lock = add_lock({})
      lock.lock_messages
      lock
    rescue UniqueConstraintViolation
      raise 'unable to lock maildrop'
    end

    def password=(password)
      self[:password] = Password.create password
    end

    def password
      Password.new self[:password]
    end

  end

end
