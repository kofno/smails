require 'dannunzio/db'

module Dannunzio

  class Message < Sequel::Model
    many_to_one :maildrop
    one_to_one  :locked_message
    one_to_one  :lock
  end

end
