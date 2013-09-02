module Dannunzio
  class Commands

    attr_reader :session

    def initialize session
      @session = session
    end

    def process request
      command = request.chomp
      case command[0..4].upcase

      when "USER "
        mode.user *split_arguments(command)

      when "PASS "
        mode.pass glob_arguments(command)

      when "QUIT"
        mode.quit

      when "STAT"
        mode.stat

      when /LIST ?/
        args = split_arguments command
        args.empty? ?
          mode.list_all :
          mode.list(*split_arguments(command))

      when "RETR "
        mode.retr *split_arguments(command)

      when "DELE "
        mode.dele *split_arguments(command)

      when "NOOP"
        mode.noop

      when "RSET"
        mode.rset

      else
        mode.unsupported_command
      end
    end

    private

    def mode
      session.mode
    end

    def glob_arguments command
      command.split(' ', 2)[1] || ''
    end

    def split_arguments command
      glob_arguments(command).split ' '
    end

  end

end
