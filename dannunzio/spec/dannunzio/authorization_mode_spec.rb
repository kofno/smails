require 'spec_helper'

module Dannunzio

  describe AuthorizationMode do
    let(:session) { double :session }
    let(:mode)    { AuthorizationMode.new session }

    describe "client sessions sending a QUIT command" do

      it "are ended immediately" do
        session.should_receive(:close)
        mode.quit
      end

    end

    describe "client sessions sending a USER command" do

      it "receive an OK on any non-blank username" do
        session.should_receive(:send_ok)
        mode.user 'foo@foo.com'
      end

    end

    describe "client sessions sending a PASS commnd" do
      
      it "receive an ERR if authentication fails" do
        mode.should_receive(:username).and_return 'foo'
        session.should_receive(:acquire_lock!).with('foo', 'secret').and_raise 'invalid credentials'
        mode.should_receive(:reset_auth)
        mode.should_receive(:send_err).with 'invalid credentials'

        mode.pass 'secret'
      end

      it "receive an ERR if a mailbox lock can't be acquired" do
        mode.should_receive(:username).and_return 'foo'
        session.should_receive(:acquire_lock!).with('foo', 'secret').and_raise 'unable to lock maildrop'
        mode.should_receive(:reset_auth)
        mode.should_receive(:send_err).with 'unable to lock maildrop'

        mode.pass 'secret'
      end

      it "enters TRANSACTION MODE if auth succeeds and lock acquired" do
        mode.should_receive(:username).and_return 'foo'
        session.should_receive(:acquire_lock!).with 'foo', 'secret'
        session.should_receive(:send_ok).with 'maildrop is locked and ready'

        mode.pass 'secret'
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
