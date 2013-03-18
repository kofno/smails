require 'dannunzio/db'

module Dannunzio

  class DropListing

    attr_reader :lock

    def initialize lock
      @lock = lock
    end

    def to_s
      "#{count} #{octets}"
    end

    def count
      data[:count]
    end

    def octets
      data[:octets] || 0
    end

    private

    def data
      @data ||= dataset.first
    end

    def dataset
      undeleted_messages_dataset.select count_lit, sum_lit(:octets, :octets)
    end

    def undeleted_messages_dataset
      messages_dataset.where marked_deleted: false
    end

    def messages_dataset
      lock.messages_dataset
    end

    def count_lit
      count = Sequel.function :count, '*'
      Sequel.as count, :count
    end

    def sum_lit field, field_alias='sum'
      sum = Sequel.function :sum, field
      Sequel.as sum, field_alias
    end

  end

end
