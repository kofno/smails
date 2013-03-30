ENV['DANNUNZIO_BCRYPT_COST'] = '4'

require 'dannunzio'

RSpec.configure do |c|
  c.after(:each) { Dannunzio::Storage.reset }
end
