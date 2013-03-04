require 'spec_helper'

describe MailQueue do
  let(:message) { double :message }
  let(:jmx_queue) { double :jmx_queue }
  let(:queue) { MailQueue.new resource: jmx_queue }

  it 'shortens the queue name' do
    jmx_queue.should_receive(:name).and_return '/queues/mail/success'
    expect(queue.name).to eq('success')
  end

  it 'iterates over decoded messages' do
    queue.should_receive(:resource).and_return [message]
    message.should_receive(:decode).and_return subject: 'Re: Your request'
    queue.each
  end

  it 'removes all the messages from the queue' do
    jmx_queue.should_receive(:remove_messages).and_return 1
    queue.clear
  end
end
