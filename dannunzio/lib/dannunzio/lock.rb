module Dannunzio

  class Lock

    attr_reader :maildrop, :locked_messages
    private     :locked_messages

    def initialize maildrop
      @maildrop = maildrop
      populate_locked_messages
    end

    def mark_deleted index
      deleted_messages[index] = locked_message index
      locked_messages.delete(index)
    end

    def clear_deleted_messages
      maildrop.remove_messages deleted_messages.values
      deleted_messages.clear
    end

    def undelete_all
      deleted_messages.each do |index, msg|
        locked_messages[index] = msg
      end
      deleted_messages.clear
    end

    def message_content index
      locked_message(index).content
    end

    def scan_listing index
      msg = locked_message(index)
      format_listing index, msg.octets
    end

    def scan_listings
      locked_messages.map { |index, msg| format_listing index, msg.octets }
    end

    def drop_listing
      drop_listing = locked_messages.values
      size = drop_listing.size
      sum  = drop_listing.reduce(0) { |sum, msg|
        sum += msg.octets
        sum
      }
      format_listing size, sum
    end

    def ==(other)
      maildrop.identifier == other.maildrop.identifier
    end

    private

    def locked_message index
      locked_messages.fetch(index) { raise 'no such message' }
    end

    def deleted_messages
      @deleted_messages ||= {}
    end

    def populate_locked_messages
      @locked_messages = {}
      maildrop.messages.each_with_index do |msg, i|
        @locked_messages[i] = msg
      end
    end

    def format_listing(val1, val2)
      "#{val1} #{val2}"
    end
  end

end
