require 'dannunzio'

module Dannunzio

  describe Session do
    let(:store)              { double :store }
    let(:maildrop)           { double :maildrop }
    let(:client)             { double :client }
    let(:session)            { Session.new client }

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
      client.should_receive(:print).with("+OK D'Annunzio signing off \r\n").ordered
      client.should_receive(:close).ordered

      session.close
    end

    it 'authorizes a user' do
      session.should_receive(:store).and_return store
      store.should_receive(:fetch_maildrop).with('kofno').and_return maildrop
      maildrop.should_receive(:authenticated?).with('secret').and_return true

      session.authenticate! 'kofno', 'secret'
    end

    it 'raises an exception if authorization fails' do
      session.should_receive(:store).and_return store
      store.should_receive(:fetch_maildrop).with('kofno').and_return maildrop
      maildrop.should_receive(:authenticated?).with('secret').and_return false

      expect { session.authenticate! 'kofno', 'secret' }.to raise_error('invalid credentials')
    end

    it 'locks a maildrop'
  end

end
