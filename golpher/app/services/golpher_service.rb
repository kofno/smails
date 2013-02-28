class GolpherService

  attr_reader :server

  def initialize config
    options = config.symbolize_keys.merge(default_server_options)
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

  def default_server_options
    { processor: processor, logger: Rails.logger }
  end
end
