module Golpher

  describe Server do

    let(:logger) { double(:logger) }
    let(:processor) { double(:processor) }
    let(:server) {
      Server.new interval:  60,
                 processor: processor,
                 logger:    logger,
                 server:    'pop.gmail.com',
                 port:      995,
                 username:  'a.user@gmail.com',
                 password:  'sekrit',
                 ssl:       true
    }

    it 'runs the server' do
      server.should_receive :start

      server.run
    end

    it 'starts the loop' do
      server.logger.should_receive(:info).with 'Golpher server started'
      server.should_receive :start_loop
      server.logger.should_receive(:info).with 'Golpher server stopped'

      server.start
    end

    it 'processes messages' do
      client = double(:client)
      server.should_receive(:client).and_return client
      client.should_receive(:messages).and_yield '<message 1>'
      processor.should_receive(:process).with '<message 1>'

      server.process_messages
    end

    it 'logs errors during message processing' do
      client = double(:client)
      server.should_receive(:client).and_return client
      error = Timeout::Error.new
      client.should_receive(:messages).and_raise error
      server.logger.should_receive(:error).with error

      server.process_messages
    end
  end

end
