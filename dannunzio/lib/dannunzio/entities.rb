require 'data_mapper'
require 'dm-is-list'

module Dannunzio
  class Maildrop
    include DataMapper::Resource

    property :id,       Serial
    property :username, String, required: true, unique: true
    property :password, BCryptHash, required: true

    has n, :messages
    has 1, :lock

    def self.authenticate! args
      username = args.fetch :username
      password = args.fetch :password

      maildrop = Maildrop.first username: username
      maildrop.nil? ?
        raise('invalid credentials') :
        maildrop.authenticate!(password)
    end

    # Race condition!
    # TODO: come back and do something more database-y
    def acquire_lock!
      raise 'unable to lock maildrop' unless lock.nil?
      self.lock = Lock.new
      self.save
      self.lock
    end

    def authenticate! password
      self.password == password ?
        self : raise('invalid credentials')
    end

  end

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

  class Message
    include DataMapper::Resource

    property :id,      Serial
    property :content, Text, required: true
    property :octets,  Integer, required: true, default: ->(r, p) { r.content.bytesize }

    belongs_to :maildrop
    has n, :locked_messages

  end

  class LockedMessage
    include DataMapper::Resource

    property :lock_id,        Integer, key: true
    property :message_id,     Integer, key: true
    property :marked_deleted, Boolean, required: true, default: false

    belongs_to :message
    belongs_to :lock

    is :list, scope: :lock_id
  end
end

DataMapper.finalize
