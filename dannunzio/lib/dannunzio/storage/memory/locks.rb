module Dannunzio

  class LockAlreadyExists < StandardError; end

  module Memory

    class Locks

      attr_reader :locks

      def initialize
        @locks = {}
        @mutex = Mutex.new
      end

      def get(maildrop)
        Storage::MUTEX.synchronize{ locks[maildrop] }
      end
      alias_method :[], :get

      def create args
        maildrop = args[:for]
        @mutex.synchronize {
          raise LockAlreadyExists if get(maildrop)
          locks[maildrop] = Lock.new(maildrop)
        }
      end

      def release args
        maildrop = args[:for]
        @mutex.synchronize { locks.delete(maildrop) }
      end

    end

  end

end

