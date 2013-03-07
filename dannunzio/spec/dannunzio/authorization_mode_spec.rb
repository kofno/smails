require 'dannunzio'

module Dannunzio

  describe AuthorizationMode do
    let(:session) { double :session }
    let(:mode)    { AuthorizationMode.new session }

    it "responds to pop command 'quit'" do
      expect(mode.responds_to_command?(:quit)).to be_true
    end

    it "responds to pop command 'user'" do
      expect(mode.responds_to_command?(:user)).to be_true
    end

    it "responds to pop command 'pass'" do
      expect(mode.responds_to_command?(:pass)).to be_true
    end

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

    describe "client seesions sending a PASS commnd" do
      
      it "receive an ERR if authentication fails" do
        mode.should_receive(:username).and_return 'foo'
        session.should_receive(:authorize!).with('foo', 'secret').and_raise 'invalid credentials'
        session.should_receive(:send_err).with 'invalid credentials'

        mode.pass 'secret'
      end

      it "receive an ERR if a mailbox lock can't be acquired" do
        mode.should_receive(:username).twice.and_return 'foo', 'foo'
        session.should_receive(:authorize!).with 'foo', 'secret'
        session.should_receive(:lock!).with('foo').and_raise 'unable to lock maildrop'
        session.should_receive(:send_err).with 'unable to lock maildrop'

        mode.pass 'secret'
      end

      it "enters TRANSACTION MODE if auth succeeds and lock acquired" do
        mode.should_receive(:username).twice.and_return 'foo', 'foo'
        session.should_receive(:authorize!).with 'foo', 'secret'
        session.should_receive(:lock!).with 'foo'
        session.should_receive(:send_ok).with 'maildrop is locked and ready'

        mode.pass 'secret'
      end
    end

  end
end
