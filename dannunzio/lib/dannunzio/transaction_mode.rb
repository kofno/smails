require 'forwardable'

module Dannunzio

  class TransactionMode
    extend Forwardable

    attr_reader :session
    def_delegators :@session, :lock, :send_ok, :send_err, :send_multi

    def initialize session
      @session = session
    end

    def stat
      send_ok drop_listing
    end

    def list arg
      send_ok scan_listing(arg)
    rescue
      send_no_such_message
    end

    def list_all
      send_multi scan_listings
    end

    def retr arg
      send_multi lock.message_content(arg)
    rescue
      send_no_such_message
    end

    def dele arg
      lock.mark_deleted arg
      send_ok
    rescue
      send_no_such_message
    end

    def noop
      send_ok
    end

    def rset
      lock.undelete_all
      send_ok
    end

    def quit
      session.update
    end

    private

    def drop_listing
      lock.drop_listing
    end

    def scan_listings
      lock.scan_listings
    end

    def scan_listing arg
      lock.scan_listing arg
    end

    def send_no_such_message
      send_err 'no such message'
    end

  end

end
