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
      data = drop_listing_dataset.first
      MessageStats.new(data[:count], data[:octets])
    end

    def scan_listings
      scan_listing_dataset.map do |data|
        MessageStats.new(data[:index], data[:octets])
      end
    end

    def scan_listing arg
      data = scan_listing_dataset.where(index: arg).first
      raise 'no such message' unless data
      MessageStats.new(data[:index], data[:octets])
    end

    def mark_deleted scan_id
      message = locked_messages.find { |msg| msg.index == scan_id }
      raise 'no such message' unless message
      message.mark_deleted
    end

    private

    def lockable_messages
      id_lit      = Sequel.lit id.to_s
      deleted_lit = Sequel.lit 'false'
      index_lit   = Sequel.function :rownum
      dataset     = maildrop.messages_dataset
      dataset.select(id_lit, :id, deleted_lit, index_lit)
    end

    def drop_listing_dataset
      messages_dataset.
        select(count_lit, sum_lit(:octets, :octets)).
        where(marked_deleted: false)
    end

    def scan_listing_dataset
      messages_dataset.
        select(:index, :octets).
        where(marked_deleted: false)
    end

    def count_lit
      count = Sequel.function(:count, '*')
      Sequel.as(count, :count)
    end

    def sum_lit field, field_alias='sum'
      sum = Sequel.function(:sum, field)
      Sequel.as(sum, field_alias)
    end

    class MessageStats< Struct.new(:count_or_index, :octets)
      def to_s
        "#{count_or_index} #{octets || 0}"
      end
    end
  end

end
