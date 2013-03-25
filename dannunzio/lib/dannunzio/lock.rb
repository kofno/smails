require 'dannunzio/db'

module Dannunzio

  class Lock < Sequel::Model
    many_to_one :maildrop
    one_to_many :locked_messages
    many_to_many :messages, join_table: :locked_messages
    many_to_many :undeleted_messages, class: 'Dannunzio::Message',
      join_table: :locked_messages, right_key: :message_id,
      conditions: { marked_deleted: false }
    many_to_many :deleted_messages, class: 'Dannunzio::Message',
      join_table: :locked_messages, right_key: :message_id,
      conditions: { marked_deleted: true }

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
      msg = locked_messages.find { |m| m.index == scan_id }
      msg && !msg.marked_deleted ?
        msg.update(marked_deleted: true) :
        raise_no_message!
    end

    def message_content scan_id
      messages = messages { |ds| ds.where(marked_deleted: false, index: scan_id) }
      message = messages.first || raise_no_message!
      message.content
    end

    def undelete_all
      locked_messages { |ds| ds.where(marked_deleted: true) }.each { |rec|
        rec.update(marked_deleted: false)
      }
    end

    def clean_and_release
      messages { |ds| ds.where(marked_deleted: true) }.each { |msg|
        msg.destroy
      }
      destroy
    end

    private

    def raise_no_message!
      raise 'no such message'
    end

    def undeleted_message scan_id
      undeleted_message_dataset(scan_id).first or raise_no_message!
    end

    def undeleted_message_dataset scan_id
      undeleted_messages_dataset.where(index: scan_id)
    end

    def lockable_messages
      id_lit      = Sequel.lit id.to_s
      deleted_lit = Sequel.lit 'false'
      index_lit   = Sequel.function :rownum
      dataset     = maildrop.messages_dataset
      dataset.select id_lit, :id, deleted_lit, index_lit
    end

  end

end
