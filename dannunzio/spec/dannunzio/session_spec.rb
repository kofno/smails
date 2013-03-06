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
  end

end
