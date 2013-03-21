module Dannunzio

  class CommandFactory

    def self.parse request
      case request[0..4].upcase
      when "USER "
        UserCommand.new request
      when "PASS "
        PassCommand.new request
      when "QUIT"
        QuitCommand.new request
      when "STAT"
        StatCommand.new request
      when /LIST ?/
        ListCommand.new request
      when "RETR "
        RetrCommand.new request
      when "DELE "
        DeleCommand.new request
      when "NOOP"
        NoopCommand.new request
      when "RSET"
        RsetCommand.new request
      else
        raise UnsupportedCommand
      end
    end

  end

end
