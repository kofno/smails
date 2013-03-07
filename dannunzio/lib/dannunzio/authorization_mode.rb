module Dannunzio

  class AuthorizationMode

    attr_reader :session, :username

    def initialize session
      @session = session
    end

    def responds_to_command? command
      [:quit, :user, :pass].any? { |supported| supported == command }
    end

    def quit
      session.close
    end

    def user mailbox
      @username = mailbox
      session.send_ok
    end

    def pass password
      session.authorize! username, password
      session.lock! username
      session.send_ok 'maildrop is locked and ready'
    rescue => e
      session.send_err e.message
    end

  end

end
