require_relative 'storage/memory/maildrops'
require_relative 'storage/memory/messages'
require_relative 'storage/memory/locks'

module Dannunzio

  class Storage

    MUTEX = Mutex.new

    def self.register thing, impl
      MUTEX.synchronize { stores[thing] = impl }
    end

    def self.for thing
      MUTEX.synchronize { stores[thing] }
    end

    def self.stores
      @stores ||= new
    end

    def self.reset
      MUTEX.synchronize { @stores = nil }
    end

    def initialize
      build_storage
    end

    def [](thing)
      @stores[thing]
    end

    def []=(thing, impl)
      @stores[thing] = impl
    end

    private

    def build_storage
      @stores = {}
      @stores[:maildrops] = Memory::Maildrops.new
      @stores[:messages]  = Memory::Messages.new
      @stores[:locks]     = Memory::Locks.new
    end

  end

end
