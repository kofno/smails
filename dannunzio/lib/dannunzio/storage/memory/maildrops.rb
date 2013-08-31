module Dannunzio
  module Memory

    class Maildrops

      def <<(maildrop)
        Storage::MUTEX.synchronize { maildrops << maildrop }
        self
      end

      def size
        Storage::MUTEX.synchronize { maildrops.size }
      end

      def empty?
        Storage::MUTEX.synchronize { maildrops.empty? }
      end

      def fetch_by_username username
        Storage::MUTEX.synchronize {
          maildrops.find { |maildrop| maildrop.username == username }
        }
      end

      def first
        Storage::MUTEX.synchronize { maildrops.first }
      end

      def last
        Storage::MUTEX.synchronize { maildrops.last }
      end

      private

      def maildrops
        @maildrops ||= []
      end
    end

  end
end