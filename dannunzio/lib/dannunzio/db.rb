require 'jdbc/hsqldb'
require 'sequel'
require 'logger'

Jdbc::HSQLDB.load_driver

module Dannunzio

  DB = Sequel.connect "jdbc:hsqldb:file:#{ENV['DANNUNZIO_DB'] || '~/.dannunzio/db/pop'}",
    user: 'SA', password: ''
  DB.logger = logger

  Sequel::Model.db = DB

end
