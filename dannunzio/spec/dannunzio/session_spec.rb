require 'spec_helper'

module Dannunzio

  describe Session do
    let(:client)  { double :client }
    let(:store)   { double :store }
    let(:drop)    { double :maildrop }
    let(:lock)    { double :lock }
    let(:session) { Session.new client }

    it "starts the sessions" do
      client.should_receive(:write).with "+OK D'Annunzio POP3 is ready!\r\n"
      client.should_receive(:closed?).and_return true

      session.start
      expect(session.mode).to be_kind_of(AuthorizationMode)
    end

    it "sends +OK messages" do
      client.should_receive(:write).with "+OK foo\r\n"
      session.send_ok "foo"
    end

    it "sends -ERR messages" do
      client.should_receive(:write).with "-ERR foo\r\n"
      session.send_err "foo"
    end

    it "closes the session" do
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

    it "updates and releases lock" do
      session.should_receive(:lock).and_return lock
      lock.should_receive(:clean_and_release)
      client.should_receive(:write).with "+OK D'Annunzio signing off\r\n"
      client.should_receive(:close)

      session.update
    end

    describe "sending multiple lines in a response" do
      it "wraps output with +OK and terminating character" do
        client.should_receive(:write).with "+OK \r\n"
        client.should_receive(:write).with "A single line\r\n"
        client.should_receive(:write).with ".\r\n"

        session.send_multi "A single line"
      end

      it "send each line" do
        client.should_receive(:write).with("+OK \r\n")
        client.should_receive(:write).with("Line one\r\n")
        client.should_receive(:write).with("Line two\r\n")
        client.should_receive(:write).with(".\r\n")

        session.send_multi "Line one\r\nLine two"
      end

      it "byte stuffs '.', when encountered" do
        client.should_receive(:write).with("+OK \r\n")
        client.should_receive(:write).with("..A bytestuffed line\r\n")
        client.should_receive(:write).with(".\r\n")

        session.send_multi ".A bytestuffed line"
      end
    end
  end

end
