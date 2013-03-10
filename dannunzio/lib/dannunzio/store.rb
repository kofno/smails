require 'dannunzio/db'

module Dannunzio

  class Store

    def fetch_maildrop username
      Maildrop.find username: username
    end

  end

end
