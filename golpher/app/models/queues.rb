require 'torquebox-messaging'

class Queues
  include Enumerable

  def find_by_name name
    queue = mail_queues.find { |q| q.name == name }
    raise QueueNotFoundError, "no queue named #{name}" unless queue
    queue
  end

  def each &block
    mail_queues.each &block
  end

  private

  def mail_queues
    jmx_queues = queues.select { |q| q.name =~ /mail/ }
    jmx_queues.map { |q| MailQueue.new resource: q }
  end

  def queues
    TorqueBox::Messaging::Queue.list
  end

end
