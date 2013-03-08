module Dannunzio

  class CommandFactory

    def self.parse request
      case request[0..4].upcase
      when "USER "
        UserCommand.new request
      when "PASS "
        PassCommand.new request
      else
        raise UnsupportedCommand
      end
    end

  end

end
