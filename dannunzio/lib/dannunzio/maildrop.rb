require 'bcrypt'
require 'dannunzio/lock'

module Dannunzio

  class Maildrop
    include BCrypt

    attr_accessor :username
    attr_reader   :lock

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
      raise "unable to lock maildrop" if locked?
      @lock = Lock.new self
    end

    def locked?
      !@lock.nil?
    end

    def remove_messages dead_messages
      self.messages.delete_if do |msg|
        dead_messages.include? msg
      end
    end

    def messages
      @messages ||= []
    end

    def password=(password)
      @password = Password.create(password, cost: cost)
    end

    def password
      Password.new @password
    end

    private

    def cost
      (ENV['DANNUNZIO_BCRYPT_COST'] || BCrypt::Engine::DEFAULT_COST).to_i
    end

  end

end
