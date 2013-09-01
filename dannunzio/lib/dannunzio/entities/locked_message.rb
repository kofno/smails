module Dannunzio
  class LockedMessage
    include DataMapper::Resource

    property :lock_id,        Integer, key: true
    property :message_id,     Integer, key: true
    property :marked_deleted, Boolean, required: true, default: false

    belongs_to :message
    belongs_to :lock

    is :list, scope: :lock_id
  end
end
