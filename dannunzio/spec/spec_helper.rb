require 'dannunzio'

RSpec.configure do |c|
  DataMapper.setup(:default, 'sqlite::memory:')
  DataMapper.auto_migrate!

  c.after :each do
    Dannunzio::LockedMessage.all.destroy
    Dannunzio::Lock.all.destroy
    Dannunzio::Message.all.destroy
    Dannunzio::Maildrop.all.destroy
  end
end
