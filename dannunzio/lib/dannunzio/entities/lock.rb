module Dannunzio
  class Lock
    include DataMapper::Resource

    property :id, Serial

    belongs_to :maildrop
    has n, :locked_messages

    after :create, :lock_messages

    def mark_deleted n
      msg = undeleted.first position: n
      no_such_message! if msg.nil?
      msg.marked_deleted = true
      msg.save
    end

    def scan_listings
      undeleted.map { |locked|
        format_listing locked.position, locked.message.octets
      }
    end

    def scan_listing n
      locked = undeleted.first(position: n)
      no_such_message! if locked.nil?
      format_listing locked.position, locked.message.octets
    end

    def message_at_pos n
      lock = undeleted.first(position: n)
      no_such_message! if lock.nil?
      lock.message
    end

    def drop_listing
      format_listing *undeleted.messages.aggregate(:all.count, :octets.sum)
    end

    # purges messages marked as deleted
    def purge
      Lock.transaction do
        deleted.all.each do |lock|
          msg = lock.message
          lock.destroy
          msg.destroy
        end
      end
    end

    # resets the lock messages to undeleted. Cannot undelete messages that have
    # already been purged.
    def reset
      deleted.all.update marked_deleted: false
    end

    private

    # TODO: Implement using select into w/ row_number
    def lock_messages
      maildrop.messages.all.each do |msg|
        locked_messages.create(message: msg)
      end
    end

    def undeleted
      locked_messages.all marked_deleted: false
    end

    def deleted
      locked_messages.all marked_deleted: true
    end

    def format_listing val1, val2
      "#{val1} #{val2}"
    end

    def no_such_message!
      raise 'no such message'
    end

  end
end
