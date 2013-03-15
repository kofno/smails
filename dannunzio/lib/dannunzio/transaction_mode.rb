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

    def list arg=nil
      arg ?
        send_ok(scan_listing(arg)) :
        send_multi(scan_listings)
    rescue
      send_err 'no such message'
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

  end

end
