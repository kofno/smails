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
end
