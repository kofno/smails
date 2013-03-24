
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
      client.write "+OK #{msg}".pop_terminate
    end

    def send_err msg=""
      client.write "-ERR #{msg}".pop_terminate
    end

    def send_multi msg
      send_ok
      send_lines msg
      send_terminate_multi
    end

    def send_sign_off
      send_ok "D'Annunzio signing off"
    end

    def close
      client.close
    end

    def acquire_lock! username, password
      authenticate! username, password
      lock_maildrop!
      transaction_mode
    end

    def update
      lock.clean_and_release
      send_sign_off
    rescue
      send_err
    ensure
      close
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

    def send_lines msg
      msg.each_line do |line|
        client.write line.pop_terminate
      end
    end

    def send_terminate_multi
      client.write '.'.pop_terminate
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
