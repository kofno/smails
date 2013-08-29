module Dannunzio
  class Commands

    attr_reader :session

    def initialize session
      @session = session
    end

    def process request
      case request.chomp[0..4].upcase

      when "USER "
        mode.user *split_arguments(request)

      when "PASS "
        mode.pass glob_arguments(request)

      when "QUIT"
        mode.quit

      when "STAT"
        mode.stat

      when /LIST ?/
        args = split_arguments request
        args.empty? ?
          mode.list_all :
          mode.list(*split_arguments)

      when "RETR "
        mode.retr *split_arguments(request)

      when "DELE "
        mode.dele *split_arguments(request)

      when "NOOP"
        mode.noop

      when "RSET"
        mode.rset

      else
        raise UnsupportedCommand
      end
    end

    private

    def mode
      session.mode
    end

    def glob_arguments request
      request.split(' ', 2)[1] || ''
    end

    def split_arguments request
      glob_arguments(request).split ' '
    end

  end

  class UnsupportedCommand < StandardError; end
end
