module Dannunzio

  class MemoryStorage

    def initialize
      @storage = []
    end

    def <<(maildrop)
      @storage << maildrop
    end

    def fetch_by_username username
      @storage.find { |maildrop| maildrop.username == username }
    end
  end

end
