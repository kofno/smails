module Dannunzio
  class Message
    include DataMapper::Resource

    property :id,      Serial
    property :content, Text, required: true
    property :octets,  Integer, required: true, default: ->(r, p) { r.content.bytesize }

    belongs_to :maildrop
    has n, :locked_messages
  end
end
