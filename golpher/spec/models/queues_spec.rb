require 'spec_helper'

describe Queues do
  let(:queues) { Queues.new }
  let(:success_queue) { double :success_queue, name: 'success' }

  it { expect(queues).to respond_to(:each) }

  it 'gets the list of queues' do
    queues.should_receive(:mail_queues).and_return []
    queues.each
  end

  it 'finds a queue by name' do
    queues.should_receive(:mail_queues).and_return [success_queue]
    expect(queues.find_by_name('success')).to eq(success_queue)
  end

  it "raises an errors if the queue isn't found" do
    queues.should_receive(:mail_queues).and_return [success_queue]
    expect { queues.find_by_name('failed') }.to raise_error(QueueNotFoundError)
  end

end
