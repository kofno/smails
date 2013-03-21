require 'logger'

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
  autoload :QuitCommand,       'dannunzio/command'
  autoload :StatCommand,       'dannunzio/command'
  autoload :ListCommand,       'dannunzio/command'
  autoload :RetrCommand,       'dannunzio/command'
  autoload :DeleCommand,       'dannunzio/command'
  autoload :NoopCommand,       'dannunzio/command'
  autoload :RsetCommand,       'dannunzio/command'

  autoload :DB,                'dannunzio/db'
  autoload :Schema,            'dannunzio/schema'
  autoload :Maildrop,          'dannunzio/maildrop'
  autoload :Lock,              'dannunzio/lock'
  autoload :LockedMessage,     'dannunzio/locked_message'
  autoload :Message,           'dannunzio/message'

  autoload :DropListing,       'dannunzio/drop_listing'
  autoload :ScanListings,      'dannunzio/scan_listings'

  class << self
    def logger
      @@logger ||= define_logger
    end

    def define_logger
      log_dev =   ENV['DANNUNZIO_LOG']       || 'log/pop3.log'
      log_shift = ENV['DANNUNZIO_LOG_SHIFT'] || 'daily'
      log_level = ENV['DANNUNZIO_LOG_LEVEL'] || 'debug'

      logger = Logger.new(log_dev, log_shift)
      logger.level = Logger.const_get log_level.upcase
      logger
    end
  end
end
