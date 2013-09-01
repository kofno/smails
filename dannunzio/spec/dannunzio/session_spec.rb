require 'spec_helper'
require 'dannunzio/session'

module Dannunzio

  describe Session do
    let(:client)  { double :client }
    let(:session) {
      Session.new client: client
    }

    before { Maildrop.create username: 'kofno', password: 'secret' }

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
      session.acquire_lock! "kofno", "secret"
      expect(session.lock).to_not be_nil
      expect(session.mode).to be_kind_of(TransactionMode)
    end

    it "updates and releases lock" do
      session.acquire_lock! "kofno", "secret"
      
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
