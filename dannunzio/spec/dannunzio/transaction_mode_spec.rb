require 'spec_helper'

module Dannunzio

  describe TransactionMode do
    let(:session) { double :session }
    let(:lock) { double :lock }
    let(:mode) { TransactionMode.new session }
    let(:stats) { '2 320' }

    it 'responds to a STAT request' do
      session.should_receive(:lock).and_return lock
      lock.should_receive(:message_stats).and_return stats
      session.should_receive(:send_ok).with stats

      mode.stat
    end
  end

end
