module Golpher

  describe MessageProcessor do

    let(:success_queue) { double(:success_queue) }
    let(:failure_queue) { double(:failure_queue) }
    let(:processor) {
      MessageProcessor.new sucess_handler:  success_queue,
                           failure_handler: failure_queue
    }

    it 'puts good messages on the success queue' do
      message = double(:message)
      parsed  = double(:parsed)
      processor.should_receive(:parse_message).with(message).and_return parsed
      processor.should_receive(:queue_incoming).with parsed

      processor.process message
    end

    it 'puts bad messages on the failure queue' do
      message = double(:message)
      error   = StandardError.new 'Something bad'
      processor.should_receive(:parse_message).with(message).and_raise error
      processor.should_receive(:queue_failure).with(message: error.message,
                                                    content: message)

      processor.process message
    end
  end

end
