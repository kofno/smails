require 'socket'
require_relative 'session'
require_relative 'commands'
require_relative 'entities'

module Dannunzio

  class Server

    attr_reader :port

    def self.run args={}
      server = new args
      server.start
    end

    def initialize args={}
      @port = args.fetch :port, 110
      initialize_db args
      trap(:INT) { exit }
    end

    def start
      Dannunzio.logger.info 'Starting server'
      Thread.abort_on_exception = true
      loop do
        start_thread
      end
      Dannunzio.logger.info 'Server stopped'
    end

    private

    def initialize_db args={}
      db_url = args.fetch :db, 'sqlite::memory:'
      DataMapper.setup :default, db_url
      DataMapper.auto_upgrade!
    end

    def start_thread
      Thread.start(tcp_server.accept) do |client|
        start_session client
      end
    end

    def start_session client
      Dannunzio.logger.info 'Starting a session'
      session = Session.new client: client
      session.start
    rescue => e
      Dannunzio.logger.error e
    end

    def tcp_server
      @tcp_server ||= TCPServer.new port
    end
  end

end
