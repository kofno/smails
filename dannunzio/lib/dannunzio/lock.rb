require 'dannunzio/db'

module Dannunzio

  class Lock < Sequel::Model
    many_to_one :maildrop
    one_to_many :locked_messages
    many_to_many :messages, join_table: :locked_messages
    many_to_many :undeleted_messages, class: 'Dannunzio::Message',
      join_table: :locked_messages, right_key: :message_id,
      conditions: { marked_deleted: false }

    def lock_messages
      locked_messages_dataset.insert(lockable_messages)
    end

    def drop_listing
      DropListing.new self
    end

    def scan_listings
      ScanListings.new self
    end

    def scan_listing scan_id
      scan_listings.filter_by_scan_id(scan_id).first or raise_no_message!
    end

    def mark_deleted scan_id
      dataset = locked_messages_dataset.where(marked_deleted: false, index: scan_id)
      unless dataset.update(marked_deleted: true) > 0
        raise_no_message!
      end
    end

    def message_content scan_id
      undeleted_message(scan_id).content.split("\r\n")
    end

    def undelete_all
      locked_messages_dataset.update(marked_deleted: false)
    end

    private

    def raise_no_message!
      raise 'no such message'
    end

    def undeleted_message scan_id
      undeleted_message_dataset(scan_id).first or raise 'no such message'
    end

    def lockable_messages
      id_lit      = Sequel.lit id.to_s
      deleted_lit = Sequel.lit 'false'
      index_lit   = Sequel.function :rownum
      dataset     = maildrop.messages_dataset
      dataset.select id_lit, :id, deleted_lit, index_lit
    end

    def undeleted_message_dataset scan_id
      undeleted_messages_dataset.where(index: scan_id)
    end

  end

end
