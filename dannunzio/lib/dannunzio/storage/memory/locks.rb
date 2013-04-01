module Dannunzio

  class LockAlreadyExists < StandardError; end

  module Memory

    class Locks

      attr_reader :locks

      def initialize
        @locks = {}
        @mutex = Mutex.new
      end

      def [](key)
        Storage::MUTEX.synchronize{ locks[key] }
      end

      def []=(key, value)
        @mutex.synchronize {
          raise LockAlreadyExists if value && !self[key].nil?
          locks[key] = value
        }
      end

    end

  end

end
