require 'spec_helper'

module Dannunzio

  describe TransactionMode do
    let(:session) { double :session }
    let(:lock) { double :lock }
    let(:mode) { TransactionMode.new session }
    let(:stats) { '2 320' }
    let(:scan_listings) { ['1 200', '2 120'] }
    let(:scan_listing)  { '1 200' } 

    it 'responds to a STAT request' do
      session.should_receive(:lock).and_return lock
      lock.should_receive(:drop_listing).and_return stats
      session.should_receive(:send_ok).with stats

      mode.stat
    end

    it 'responds to a LIST request' do
      session.should_receive(:lock).and_return lock
      lock.should_receive(:scan_listings).and_return scan_listings
      session.should_receive(:send_multi).with(scan_listings)

      mode.list
    end

    it 'responds to a LIST 1 request' do
      session.should_receive(:lock).and_return lock
      lock.should_receive(:scan_listing).with(1).and_return scan_listing
      session.should_receive(:send_ok).with scan_listing

      mode.list 1
    end

    it 'sends an -ERR when LISTing a deleted message' do
      session.should_receive(:lock).and_return lock
      lock.should_receive(:scan_listing).with(3).and_raise 'no such message'
      session.should_receive(:send_err).with 'no such message'

      mode.list 3
    end
  end

end
