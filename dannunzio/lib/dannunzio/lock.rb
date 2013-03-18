require 'dannunzio/db'

module Dannunzio

  class Lock < Sequel::Model
    many_to_one :maildrop
    one_to_many :locked_messages
    many_to_many :messages, join_table: :locked_messages

    def lock_messages
      locked_messages_dataset.insert(lockable_messages)
    end

    def drop_listing
      DropListing.new self
    end

    def scan_listings
      scan_listings_dataset.map do |data|
        MessageStats.new(data[:index], data[:octets])
      end
    end

    def scan_listing arg
      data = undeleted_scan_listing arg
      MessageStats.new(data[:index], data[:octets])
    end

    def mark_deleted scan_id
      message = locked_messages.find { |msg| msg.index == scan_id }
      raise 'no such message' unless message
      message.mark_deleted
    end

    def message_content scan_id
      undeleted_message(scan_id).content.split("\r\n")
    end

    def undelete_all
      locked_messages_dataset.update(marked_deleted: false)
    end

    private

    def undeleted_message scan_id
      undeleted_message_dataset(scan_id).first or raise 'no such message'
    end

    def undeleted_scan_listing scan_id
      scan_listing_dataset(scan_id).first or raise 'no such message' 
    end

    def lockable_messages
      id_lit      = Sequel.lit id.to_s
      deleted_lit = Sequel.lit 'false'
      index_lit   = Sequel.function :rownum
      dataset     = maildrop.messages_dataset
      dataset.select id_lit, :id, deleted_lit, index_lit
    end

    def scan_listings_dataset
      undeleted_messages_dataset.select :index, :octets
    end

    def scan_listing_dataset scan_id
      scan_listings_dataset.where(index: scan_id)
    end

    def undeleted_messages_dataset
      messages_dataset.where marked_deleted: false
    end

    def undeleted_message_dataset scan_id
      undeleted_messages_dataset.where(index: scan_id)
    end

    class MessageStats< Struct.new(:count_or_index, :octets)
      def to_s
        "#{count_or_index} #{octets || 0}"
      end
    end
  end

end
