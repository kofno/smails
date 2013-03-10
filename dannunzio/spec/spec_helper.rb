require 'dannunzio'

RSpec.configure do |c|
  c.around :each do |example|
    Dannunzio::DB.transaction(rollback: :always) { example.run }
  end
end
