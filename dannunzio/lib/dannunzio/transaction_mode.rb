require 'forwardable'

module Dannunzio

  class TransactionMode
    extend Forwardable
    include CommandProcessor

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
