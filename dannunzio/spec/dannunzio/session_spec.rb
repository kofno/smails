require 'spec_helper'

module Dannunzio

  describe Session do
    let(:client)  { double :client }
    let(:store)   { double :store }
    let(:drop)    { double :maildrop }
    let(:lock)    { double :lock }
    let(:session) { Session.new client }

    it "starts the sessions" do
      client.should_receive(:print).with "+OK D'Annunzio POP3 is ready!\r\n"
      client.should_receive(:gets).and_return nil

      session.start
      expect(session.mode).to be_kind_of(AuthorizationMode)
    end

    it "sends +OK messages" do
      client.should_receive(:print).with "+OK foo\r\n"
      session.send_ok "foo"
    end

    it "sends -ERR messages" do
      client.should_receive(:print).with "-ERR foo\r\n"
      session.send_err "foo"
    end

    it "closes the session" do
      client.should_receive(:print).with "+OK D'Annunzio signing off\r\n"
      client.should_receive(:close)
      session.close
    end

    it "acquires a mail drop lock" do
      Maildrop.should_receive(:find_by_username!).with("kofno").and_return drop
      drop.should_receive(:authenticate!).with('secret').and_return true
      drop.should_receive(:acquire_lock!).and_return lock

      session.acquire_lock! "kofno", "secret"
      expect(session.mode).to be_kind_of(TransactionMode)
    end

  end

end
