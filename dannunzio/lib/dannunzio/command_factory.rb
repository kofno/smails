module Dannunzio

  class CommandFactory

    def self.parse request
      case
      when request[0..4].upcase == "USER "
        UserCommand.new request
      else
        raise UnsupportedCommand
      end
    end

  end

end
