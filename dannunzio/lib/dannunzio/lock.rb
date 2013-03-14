require 'dannunzio/db'

module Dannunzio

  class Lock < Sequel::Model
    many_to_one :maildrop
    one_to_many :locked_messages
    many_to_many :messages, join_table: :locked_messages

    def lock_messages
      locked_messages_dataset.insert(lockable_messages)
    end

    def message_stats
      data = message_stats_dataset.first
      MessageStats.new(data[:count], data[:octets])
    end

    private

    def lockable_messages
      id_lit      = Sequel.lit id.to_s
      deleted_lit = Sequel.lit 'false'
      index_lit   = Sequel.function :rownum
      dataset     = maildrop.messages_dataset
      dataset.select(id_lit, :id, deleted_lit, index_lit)
    end

    def message_stats_dataset
      messages_dataset.select(count_lit, sum_lit(:octets, :octets))
    end

    def count_lit
      count = Sequel.function(:count, '*')
      Sequel.as(count, :count)
    end

    def sum_lit field, field_alias='sum'
      sum = Sequel.function(:sum, field)
      Sequel.as(sum, field_alias)
    end

    class MessageStats < Struct.new(:count, :octets)
      def to_s
        "#{count} #{octets || 0}"
      end
    end
  end

end
