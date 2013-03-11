require 'dannunzio/db'

module Dannunzio

  class Lock < Sequel::Model
    many_to_one :maildrop
    one_to_many :locked_messages
    many_to_many :messages, join_table: :locked_messages
  end

end
