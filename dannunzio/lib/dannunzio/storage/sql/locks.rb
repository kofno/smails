require_relative 'connection'

module Dannunzio
  module SQL

    class Locks
      include Connection

      def [](maildrop)
        record = db[:locks].where(maildrop_id: maildrop.identifier).first
        record ? Lock.new(maildrop) : nil
      end

      def create(args)
        maildrop = args[:for]
        identifier = maildrop.identifier
        db[:locks].insert maildrop_id: identifier
        Lock.new maildrop
      end

      def release(args)
        maildrop = args[:for]
        identifier = maildrop.identifier
        db[:locks].where(maildrop_id: identifier).delete
      end

    end
  end
end
