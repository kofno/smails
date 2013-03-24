require 'dannunzio/db'

module Dannunzio

  class ScanListings
    include Enumerable

    attr_reader :lock

    def initialize lock
      @lock = lock
    end

    def each
      dataset.each { |record|
        yield format_listing(record) if block_given?
      }
    end

    # Behave like a multi-line string
    alias_method :each_line, :each

    def filter_by_scan_id scan_id
      dataset.where(index: scan_id).map { |record|
        format_listing record
      }
    end

    private

    def dataset
      lock.undeleted_messages_dataset.select :index, :octets
    end

    def format_listing record
      "#{record[:index]} #{record[:octets]}"
    end

  end

end
