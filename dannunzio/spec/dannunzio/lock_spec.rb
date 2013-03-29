require 'spec_helper'
require 'dannunzio/lock'
require 'dannunzio/maildrop'
require 'dannunzio/message'

module Dannunzio

  describe Lock do
    let(:msg1) { "<Example 1>\r\n<Line 2>" }
    let(:msg2) { "<Example 2>\r\n<Line 2>" }
    let(:msg3) { "<Example 3>\r\n<Line 2>" }
    let(:drop) {
      drop = Maildrop.new
      drop << Message.new(msg1)
      drop << Message.new(msg2)
      drop << Message.new(msg3)
      drop
    }
    let(:lock) { drop.acquire_lock! }

    before :each do
      lock.mark_deleted 2
    end

    it 'returns message stats' do
      expect(lock.drop_listing.to_s).to eql('2 42')
    end

    it 'returns a full scan listing' do
      listings = lock.scan_listings
      expect(listings.size).to eq(2)
      expect(listings[0].to_s).to eq('0 21')
      expect(listings[1].to_s).to eq('1 21')
    end

    it 'returns a single scan listing' do
      expect(lock.scan_listing(1).to_s).to eq('1 21')
    end

    it 'raises an error when single listing a deleted message' do
      expect { lock.scan_listing 2 }.to raise_error 'no such message'
    end

    it 'returns the content of a message' do
      content = lock.message_content 0
      expect(content).to eq(msg1)
    end

    it 'raises an error when trying to return a deleted message' do
      expect { lock.message_content 2 }.to raise_error 'no such message'
    end

    it 'raises an error trying to delete a deleted message' do
      expect { lock.mark_deleted 2 }.to raise_error 'no such message'
    end

    it 'undeletes all messages' do
      lock.undelete_all
      expect(lock.message_content(2)).to eq(msg3)
    end

    it 'completely destroys messages marked deleted' do
      lock.clear_deleted_messages
      expect(drop.messages.size).to eq(2)
    end
  end

end
