require 'dannunzio/maildrop'

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
      storage.find { |drop| drop.username == options[:username] } ||
        raise('invalid credentials')
    end

    def storage
      @storage ||= []
    end
  end

end
