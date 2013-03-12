
module Dannunzio

  class Session

    attr_reader :client, :mode, :maildrop, :lock

    def initialize client
      @client = client
    end

    def start
      send_greeting
      authorization_mode
      receive_commands
    end

    def send_ok msg=""
      client.print "+OK #{msg}\r\n"
    end

    def send_err msg=""
      client.print "-ERR #{msg}\r\n"
    end

    def close
      send_ok "D'Annunzio signing off"
      client.close
    end

    def acquire_lock! username, password
      authenticate! username, password
      lock_maildrop!
      transaction_mode
    end

    private

    def authenticate! username, password
      @maildrop = Maildrop.find_by_username! username
      maildrop.authenticate! password
    end

    def lock_maildrop!
      @lock ||= maildrop.acquire_lock!
    end

    def send_greeting
      send_ok "D'Annunzio POP3 is ready!"
    end

    def authorization_mode
      @mode = AuthorizationMode.new self
    end

    def transaction_mode
      @mode = TransactionMode.new self
    end

    def receive_commands
      while command = client.gets
        mode.process_command command
      end
    end
  end

end
