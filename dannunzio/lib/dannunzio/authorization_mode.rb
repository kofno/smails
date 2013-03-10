require 'forwardable'

module Dannunzio

  class AuthorizationMode
    extend Forwardable
    include CommandProcessor

    attr_reader :session, :username
    def_delegators :@session, :send_ok, :send_err

    def initialize session
      @session = session
    end

    def quit
      session.close
    end

    def user mailbox
      @username = mailbox
      send_ok
    end

    def pass password
      session.acquire_lock! username, password
      send_ok 'maildrop is locked and ready'
    rescue => e
      reset_auth
      send_err e.message
    end

    def unsupported_command
      reset_auth
      super
    end

    def reset_auth
      @username = nil
    end

  end

end
