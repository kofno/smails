class MailQueue
  include Enumerable

  attr_reader :resource
  private     :resource

  def initialize args
    @resource = args[:resource]
  end

  def name
    resource.name.rpartition('/').last
  end

  def each &block
    decoded_messages.each &block
  end

  def clear
    resource.remove_messages
  end

  private

  def decoded_messages
    resource.map(&:decode)
  end

end
