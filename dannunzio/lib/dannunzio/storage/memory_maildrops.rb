module Dannunzio
  class MemeryMaildrops

    def <<(maildrop)
      Storage::MUTEX.synchronize { maildrops << maildrop }
    end

    def fetch_by_username username
      Storage::MUTEX.synchronize {
        maildrops.find { |maildrop| maildrop.username == username }
      }
    end

    private

    def maildrops
      @maildrops ||= []
    end
  end
end
