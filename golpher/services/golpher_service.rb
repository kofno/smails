require 'golpher'

class GolpherService
  include Golpher

  attr_reader :server

  def initialize config
    options = symbolize(config).merge(processor: processor)
    @server = Server.new options
  end

  def start
    Thread.new { server.run }
  end

  def stop
    server.stop
  end

  private

  def processor
    MessageProcessor.new success_handler: list_messages_queue,
                         failure_handler: failed_message_queue
  end

  def list_messages_queue
    TorqueBox::Messaging::Queue.new('/queues/mail_lists')
  end

  def failed_message_queue
    TorqueBox::Messaging::Queue.new('/queues/failed_mail')
  end

  def symbolize(hash)
    hash.reduce({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
  end
end
