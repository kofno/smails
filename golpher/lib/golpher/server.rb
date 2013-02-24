require 'logger'

module Golpher

  class Server
    attr_reader :client, :interval, :logger, :processor

    def initialize options
      @interval  = options.delete(:interval) || 60
      @processor = options.delete(:processor)
      @logger    = options.delete(:logger) || Logger.new(STDOUT)
      @client    = Pop3Client.new options
    end

    def run
      start
    rescue => e
      logger.fatal e
    end

    def stop
      @running = false
    end

    def running?
      @running && interval > 0
    end

    def start
      logger.info "Golpher server started"
      start_loop
      logger.info "Golpher server stopped"
    end

    def start_loop
      @running = true
      while running?
        logger.info "Golpher getting messages"
        process_messages

        sleep interval
      end
    end

    def process_messages
      client.messages do |message|
        processor.process message
      end
    rescue => e
      logger.error e
    end
  end
end
