require 'set'

module Dannunzio

  class Lock

    attr_reader :maildrop, :locked_messages
    private     :locked_messages

    def initialize maildrop
      @maildrop = maildrop
      @locked_messages = maildrop.messages.dup
    end

    def mark_deleted index
      deleted_messages << undeleted_message(index)
    end

    def clear_deleted_messages
      maildrop.remove_messages deleted_messages
      deleted_messages.clear
    end

    def undelete_all
      deleted_messages.clear
    end

    def message_content index
      msg = undeleted_message index
      msg.content
    end

    def scan_listing index
      msg = undeleted_message index
      "#{index} #{msg.octets}"
    end

    def scan_listings
      i = 0
      undeleted_messages.map do |msg|
        i += 1
        scan_listing(i) unless msg.nil?
      end.compact
    end

    def drop_listing
      drop_listing = undeleted_messages.compact
      size = drop_listing.size
      sum  = drop_listing.reduce(0) { |sum, msg|
        sum += msg.octets
        sum
      }
      "#{size} #{sum}"
    end

    private

    def undeleted_message index
      msg = undeleted_messages[index - 1]
      raise 'no such message' if msg.nil?
      msg
    end

    def deleted_messages
      @deleted_messages ||= Set.new
    end

    def undeleted_messages
      locked_messages.map { |msg|
        msg unless deleted_messages.include?(msg)
      }
    end
  end

end
