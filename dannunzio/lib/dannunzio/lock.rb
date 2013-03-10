require 'dannunzio/db'

module Dannunzio

  class Lock < Sequel::Model
    many_to_one :maildrop
  end

end
