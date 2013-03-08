
module Dannunzio

  class Session

    attr_reader :client, :mode

    def initialize client
      @client = client
    end

    def start
      send_greeting
      authorization_mode
      receive_commands
    end

    def send_ok msg=""
      client.print "+OK #{msg} \r\n"
    end

    def send_err msg=""
      client.print "-ERR #{msg} \r\n"
    end

    def close
      send_ok "D'Annunzio signing off"
      client.close
    end

    private

    def send_greeting
      send_ok "D'Annunzio POP3 is ready!"
    end

    def authorization_mode
      @mode = AuthorizationMode.new
    end

    def receive_commands
      while command = client.gets
        mode.process_command command
      end
    end
  end

end
