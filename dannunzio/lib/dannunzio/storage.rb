require_relative 'storage/memory_maildrops'

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
      @stores[:maildrops] = MemeryMaildrops.new
    end

  end

end
