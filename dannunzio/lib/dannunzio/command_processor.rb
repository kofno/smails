module Dannunzio

  class UnsupportedCommand < StandardError; end

  module CommandProcessor

    def process_command request
      command = parser.parse request
      command.execute self
    rescue UnsupportedCommand => e
      unsupported_command
    end

    def parser
      CommandFactory
    end

    def unsupported_command
      send_err 'unrecognized command'
    end

  end
end
