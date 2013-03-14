require 'dannunzio/db'

module Dannunzio

  class LockedMessage < Sequel::Model
    many_to_one :lock
    many_to_one :message
  end
end
