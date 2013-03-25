ENV['DANNUNZIO_DB'] = '~/.dannunzio/db/test'

RSpec.configure do |c|

  c.before :suite do
    require 'dannunzio/schema'
    Dannunzio::Schema.load
    require 'dannunzio'
  end

  c.around :each do |example|
    Dannunzio::DB.transaction(rollback: :always) { example.run }
  end

  c.after :suite do
    Dannunzio::Schema.implode!
  end
end
