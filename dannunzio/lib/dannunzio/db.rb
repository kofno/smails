require 'jdbc/hsqldb'
require 'sequel'

Jdbc::HSQLDB.load_driver

module Dannunzio

  DB = Sequel.connect 'jdbc:hsqldb:file:~/.dannunzio/db/pop',
    user: 'SA', password: ''

  Sequel::Model.db = DB

end
