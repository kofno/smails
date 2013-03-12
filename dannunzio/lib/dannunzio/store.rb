require 'dannunzio/db'

module Dannunzio

  class Store

    def fetch_maildrop! username
      drop = Maildrop.find username: username
      raise 'invalid credentials' unless drop
      drop
    end

  end

end
