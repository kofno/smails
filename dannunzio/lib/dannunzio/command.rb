module Dannunzio

  class Command
    attr_reader :request, :mode

    def initialize request
      @request = request
    end

    def execute mode
      @mode = mode
      call
    rescue NoMethodError, ArgumentError
      raise UnsupportedCommand
    end
  end

  class UserCommand < Command
  end
end
