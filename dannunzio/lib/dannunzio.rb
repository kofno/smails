require 'socket'

module Dannunzio

  autoload :Server,            'dannunzio/server'
  autoload :Session,           'dannunzio/session'
  autoload :AuthorizationMode, 'dannunzio/authorization_mode'
  autoload :TransactionMode,   'dannunzio/transaction_mode'

  autoload :CommandProcessor,  'dannunzio/command_processor'
  autoload :CommandFactory,    'dannunzio/command_factory'
  autoload :Command,           'dannunzio/command'
  autoload :UserCommand,       'dannunzio/command'
  autoload :PassCommand,       'dannunzio/command'

  autoload :DB,                'dannunzio/db'
  autoload :Schema,            'dannunzio/schema'
  autoload :Maildrop,          'dannunzio/maildrop'
  autoload :Lock,              'dannunzio/lock'
  autoload :LockedMessage,     'dannunzio/locked_message'
  autoload :Message,           'dannunzio/message'

end
