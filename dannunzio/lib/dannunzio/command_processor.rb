require_relative 'command_factory'

module Dannunzio

  class UnsupportedCommand < StandardError; end

  module CommandProcessor

    def process_command request
      Dannunzio.logger.debug "Received: #{request}"
      command = parser.parse request
      command.execute self
    rescue UnsupportedCommand => e
      Dannunzio.logger.error e
      unsupported_command
    end

    def parser
      Dannunzio::CommandFactory
    end

    def unsupported_command
      send_err 'unrecognized command'
    end

  end
end
