require 'jdbc/hsqldb'
require 'sequel'
require 'logger'

Jdbc::HSQLDB.load_driver

module Dannunzio

  DB = Sequel.connect 'jdbc:hsqldb:file:~/.dannunzio/db/pop',
    user: 'SA', password: ''
  DB.logger = Logger.new(STDOUT)

  Sequel::Model.db = DB

end
