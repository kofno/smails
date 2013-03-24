require 'logger'
require 'dannunzio/core_ext/string'

module Dannunzio

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

require 'dannunzio/db'
require 'dannunzio/schema'
require 'dannunzio/maildrop'
require 'dannunzio/lock'
require 'dannunzio/locked_message'
require 'dannunzio/message'

require 'dannunzio/drop_listing'
require 'dannunzio/scan_listings'

require 'dannunzio/command'
require 'dannunzio/command_processor'
require 'dannunzio/command_factory'

require 'dannunzio/server'
require 'dannunzio/session'
require 'dannunzio/authorization_mode'
require 'dannunzio/transaction_mode'
