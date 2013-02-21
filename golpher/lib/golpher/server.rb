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
      @done = true
    end

    def done?
      !!@done || interval == 0
    end

    private

    def start
      logger.info "Golpher Server Started"
      @done = false
      until done?
        logger.info "Golpher getting messages"
        client.messages do |message|
          processor.process message
        end

        sleep interval
      end
      logger.info "Golpher Server Stopped"
    end
  end
end
