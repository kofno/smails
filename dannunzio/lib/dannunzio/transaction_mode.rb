require 'forwardable'

module Dannunzio

  class TransactionMode
    extend Forwardable
    include CommandProcessor

    attr_reader :session
    def_delegators :@session, :send_ok, :send_err, :lock

    def initialize session
      @session = session
    end

    def stat
      send_ok message_stats
    end

    private

    def message_stats
      lock.message_stats
    end

  end

end
