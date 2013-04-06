require 'bcrypt'
require 'securerandom'
require 'dannunzio/lock'

module Dannunzio

  class Maildrop
    include BCrypt

    attr_accessor :username

    def initialize attributes={}
      attributes.each do |key, value|
        __send__ "#{key}=", value
      end
    end

    def <<(message)
      messages << message
    end

    def authenticate! password
      raise 'invalid credentials' unless self.password == password
    end

    def acquire_lock!
      self.lock = Lock.new self
    rescue LockAlreadyExists
      raise "unable to lock maildrop"
    end

    def remove_messages dead_messages
      self.messages.delete_all(dead_messages)
    end

    def messages
      Storage.for(:messages)[self]
    end

    def lock=(lock)
      Storage.for(:locks)[self] = lock
    end

    def lock
      Storage.for(:locks)[self]
    end

    def password=(password)
      @password = Password.create(password, cost: cost)
    end

    def password
      Password.new @password
    end

    def identifier
      @identifier ||= SecureRandom.uuid
    end

    def identifier=(id)
      @identifier = id
    end

    def to_record
      {
        identifier: identifier,
        username:   username,
        password:   password
      }
    end

    private

    def cost
      (ENV['DANNUNZIO_BCRYPT_COST'] || BCrypt::Engine::DEFAULT_COST).to_i
    end

  end

end
