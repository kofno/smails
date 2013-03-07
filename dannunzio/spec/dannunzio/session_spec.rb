require 'dannunzio'

module Dannunzio

  describe Session do
    let(:client)  { double :client }
    let(:session) { Session.new client }

    it 'starts the session' do
      session.should_receive(:send_greeting)
      session.should_receive(:authorization_mode)
      session.should_receive(:receive_commands)

      session.start
    end

    it 'sends +OK messages' do
      client.should_receive(:print).with "+OK it's all good \r\n"

      session.send_ok "it's all good"
    end

    it 'sends -ERR messages' do
      client.should_receive(:print).with "-ERR oh noes \r\n"

      session.send_err "oh noes"
    end

    it 'closes the session' do
      client.should_receive(:close)

      session.close
    end

    it 'authorizes a user'

    it 'locks a maildrop'
  end

end
