require_relative 'memory_storage'

module Dannunzio

  class Maildrops

    def access credentials
      maildrop = fetch username: credentials[:username]
      maildrop.authenticate! credentials[:password]
      maildrop
    end

    def << maildrop
      storage << maildrop
    end


    private

    def fetch options
      storage.fetch_by_username(options[:username]) || raise('invalid credentials')
    end

    def storage
      @storage ||= MemoryStorage.new
    end
  end

end
