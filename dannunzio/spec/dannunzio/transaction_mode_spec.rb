require 'spec_helper'

module Dannunzio

  describe TransactionMode do
    let(:session) { double :session }
    let(:mode) { TransactionMode.new session }
    let(:stats) { '2 320' }

    it 'responds to a STAT request' do
      mode.should_receive(:message_stats).and_return stats
      mode.should_receive(:send_ok).with stats

      mode.stat
    end
  end

end
