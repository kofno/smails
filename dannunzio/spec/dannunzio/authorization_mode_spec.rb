require 'spec_helper'
require 'dannunzio/authorization_mode'

module Dannunzio

  describe AuthorizationMode do
    let(:client)  { double :client  }
    let(:session) { Session.new client: client }
    let(:mode)    { session.send :authorization_mode }

    before { Maildrop.create username: 'kofno', password: 'secret' }

    describe "client sessions sending a QUIT command" do

      it "are ended immediately" do
        client.should_receive(:write).with "+OK D'Annunzio signing off\r\n"
        client.should_receive :close
        mode.quit
      end

    end

    describe "client sessions sending valid credentials" do

      it "receive an OK message and lock the maildrop" do
        client.should_receive(:write).with "+OK \r\n"
        client.should_receive(:write).with "+OK maildrop is locked and ready\r\n"

        mode.user 'kofno'
        mode.pass 'secret'

        expect(session.mode).to_not be(mode)
      end

      it "receive an err if the maildrop can't be locked" do
        Maildrop.first(username: 'kofno').acquire_lock!

        client.should_receive(:write).with "+OK \r\n"
        client.should_receive(:write).with "-ERR unable to lock maildrop\r\n"

        mode.user 'kofno'
        mode.pass 'secret'

        expect(session.mode).to be(mode)
      end

    end

    describe "client sessions sending invalid credentials" do
      
      it "receive an ERR if maildrop isn't recognized" do
        client.should_receive(:write).with "+OK \r\n"
        client.should_receive(:write).with "-ERR invalid credentials\r\n"

        mode.user 'not-a-maildrop'
        mode.pass 'secret'

        expect(session.mode).to be(mode)
      end

      it "receive an ERR is password is incorrect" do
        client.should_receive(:write).with "+OK \r\n"
        client.should_receive(:write).with "-ERR invalid credentials\r\n"

        mode.user 'kofno'
        mode.pass 'bad-pass'

        expect(session.mode).to be(mode)
      end

    end

    describe "unsupported commands" do

      it "resets authorization state" do
        mode.should_receive :reset_auth
        session.should_receive(:send_err).with 'unrecognized command'

        mode.unsupported_command
      end

    end

  end
end
