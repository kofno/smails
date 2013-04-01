require_relative 'storage/memory/maildrops'
require_relative 'storage/memory/messages'
require_relative 'storage/memory/locks'

module Dannunzio

  class Storage

    MUTEX = Mutex.new

    def self.for thing
      MUTEX.synchronize {
        @stores ||= new
        @stores[thing]
      }
    end

    def self.reset
      MUTEX.synchronize {
        @stores = nil
      }
    end

    def initialize
      build_storage
    end

    def [](thing)
      @stores[thing]
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
