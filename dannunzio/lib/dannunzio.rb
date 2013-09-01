require 'logger'

module Dannunzio

  class << self
    def logger
      @@logger ||= define_logger
    end

    def define_logger
      log_dev =   ENV['DANNUNZIO_LOG']       || 'log/pop3.log'
      log_shift = ENV['DANNUNZIO_LOG_SHIFT'] || 'daily'
      log_level = ENV['DANNUNZIO_LOG_LEVEL'] || 'debug'

      DataMapper::Logger.new(log_dev, log_level.to_sym)
      logger = Logger.new(log_dev, log_shift)
      logger.level = Logger.const_get log_level.upcase
      logger
    end
  end
end

require 'dannunzio/core_ext/string'
require 'dannunzio/server'
