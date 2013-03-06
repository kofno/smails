
module Dannunzio

  class Session

    attr_reader :client

    def initialize client
      @client = client
    end

    def start
      send_greeting
      authorization_mode
      receive_commands
    end

    private

    def send_greeting
      client.print "+OK D'Annunzio POP3 is ready!\r\n"
    end

    def authorization_mode
    end
  end

end
