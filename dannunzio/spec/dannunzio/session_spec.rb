require 'spec_helper'

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

    it 'acquires a lock and enters transaction mode' do
      session.should_receive(:authenticate!).with 'kofno', 'secret'
      session.should_receive(:lock!)
      session.should_receive(:transaction_mode)

      session.acquire_lock! 'kofno', 'secret'
    end
  end

end
