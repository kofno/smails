module Dannunzio

  class Command
    attr_reader :request, :mode, :arguments

    def initialize request
      @request = request
      @arguments = request.split(' ', 2).last
    end

    def execute mode
      @mode = mode
      call
    rescue NoMethodError, ArgumentError
      raise UnsupportedCommand
    end

    private

    def split_arguments
      arguments.split(' ')
    end

    def glob_arguments
      arguments
    end
  end

  class UserCommand < Command
    def call
      mode.user *split_arguments
    end
  end

  class PassCommand < Command
    def call
      mode.pass glob_arguments
    end
  end
end