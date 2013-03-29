require 'dannunzio/maildrops'
require 'dannunzio/authorization_mode'
require 'dannunzio/transaction_mode'

module Dannunzio

  class Session

    attr_reader :client, :mode, :maildrops, :maildrop, :lock

    def initialize args
      @client = args.fetch(:client)
      @maildrops = args.fetch(:maildrops, Maildrops.new)
    end

    def start
      send_greeting
      authorization_mode
      receive_commands
    end

    def send_ok msg=""
      client.write "+OK #{msg}".pop_line_terminate
    end

    def send_err msg=""
      client.write "-ERR #{msg}".pop_line_terminate
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
      lock.clear_deleted_messages
      send_sign_off
    rescue => e
      Dannunzio.logger.error(e)
      send_err
    ensure
      close
    end

    private

    def authenticate! username, password
      @maildrop = maildrops.access username: username, password: password
    end

    def lock_maildrop!
      @lock ||= maildrop.acquire_lock!
    end

    def send_greeting
      send_ok "D'Annunzio POP3 is ready!"
    end

    def send_lines msg
      msg.each_line do |line|
        client.write line.pop_bytestuff.pop_line_terminate
      end
    end

    def send_terminate_multi
      client.write String::POP_TERMINATE_MULTI.pop_line_terminate
    end

    def authorization_mode
      @mode = AuthorizationMode.new self
    end

    def transaction_mode
      @mode = TransactionMode.new self
    end

    def receive_commands
      until client.closed?
        command = client.gets
        mode.process_command command
      end
    ensure
      lock.release if locked?
    end

    def locked?
      !@lock.nil?
    end

  end

end
