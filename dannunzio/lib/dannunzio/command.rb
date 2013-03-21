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

  class StatCommand < Command
    def call
      mode.stat
    end
  end

  class ListCommand < Command
    def call
      split_arguments.empty? ?
        mode.list_all : mode.list(*split_arguments)
    end
  end

  class RetrCommand < Command
    def call
      mode.retr *split_arguments
    end
  end

  class DeleCommand < Command
    def call
      mode.dele *split_arguments
    end
  end

  class NoopCommand < Command
    def call
      mode.noop
    end
  end

  class RsetCommand < Command
    def call
      mode.rset
    end
  end

  class QuitCommand < Command
    def call
      mode.quit
    end
  end
end
