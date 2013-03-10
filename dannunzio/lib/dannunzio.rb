require 'socket'

module Dannunzio

  autoload :Server,            'dannunzio/server'
  autoload :Session,           'dannunzio/session'
  autoload :AuthorizationMode, 'dannunzio/authorization_mode'
  autoload :CommandProcessor,  'dannunzio/command_processor'
  autoload :CommandFactory,    'dannunzio/command_factory'

  autoload :Command,           'dannunzio/command'
  autoload :UserCommand,       'dannunzio/command'
  autoload :PassCommand,       'dannunzio/command'

  autoload :Store,             'dannunzio/store'
  autoload :Maildrop,          'dannunzio/maildrop'
  autoload :Schema,            'dannunzio/schema'
end
