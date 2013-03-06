require 'socket'

module Dannunzio

  class Server

    attr_reader :port

    def self.run args={}
      server = new args
      server.start
    end

    def initialize args={}
      @port = args.fetch :port, 110
    end

    def start
      loop do
        start_thread
      end
    end

    private

    def start_thread
      Thread.start(tcp_server.accept) do |client|
        start_session client
      end
    end

    def start_session client
      session = Session.new client
      session.start
    end

    def tcp_server
      @tcp_server ||= TCPServer.new port
    end
  end

end
