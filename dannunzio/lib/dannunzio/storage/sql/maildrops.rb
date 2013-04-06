require_relative 'connection'

module Dannunzio
  module SQL

    class Maildrops
      include Connection

      def empty?
        size == 0
      end

      def size
        db[:maildrops].count
      end

      def <<(maildrop)
        db[:maildrops].insert maildrop.to_record
      end

      def fetch_by_username(username)
        record = db[:maildrops].filter(username: username).first
        return unless record
        Maildrop.new record
      end

    end

  end
end
