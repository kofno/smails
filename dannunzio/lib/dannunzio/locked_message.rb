require 'dannunzio/db'

module Dannunzio

  class LockedMessage < Sequel::Model
    many_to_one :lock
    many_to_one :message

    def mark_deleted
      update marked_deleted: true
    end
  end
end
