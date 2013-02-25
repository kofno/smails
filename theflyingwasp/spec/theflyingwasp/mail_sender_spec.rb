module TheFlyingWasp

  describe MailSender do

    let(:logger) { double :logger }
    let(:sender) { MailSender.new }

    it 'blindly logs every message' do
      message = double :message
      sender.should_receive(:logger).and_return logger
      logger.should_receive(:info).with message

      sender.on_message message
    end

  end

end
