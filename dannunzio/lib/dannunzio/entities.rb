require 'data_mapper'
require 'dm-is-list'

require_relative 'entities/maildrop'
require_relative 'entities/lock'
require_relative 'entities/message'
require_relative 'entities/locked_message'

DataMapper.finalize
