require 'dannunzio'

ENV['DANNUNZIO_DB'] = '~/.dannunzio/db/test'

RSpec.configure do |c|

  c.before :suite do
    Dannunzio::Schema.load
  end

  c.around :each do |example|
    Dannunzio::DB.transaction(rollback: :always) { example.run }
  end

  c.after :suite do
    Dannunzio::Schema.implode!
  end
end
