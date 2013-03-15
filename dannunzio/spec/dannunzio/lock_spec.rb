require 'spec_helper'

module Dannunzio

  describe Lock do
    let(:drop) { Maildrop.create username: 'kofno', password: 'secret' }
    let(:lock) { drop.acquire_lock! }
    let(:msg1) { { content: '<Example 1>', octets: 212 } }
    let(:msg2) { { content: '<Example 2>', octets: 108 } }
    let(:msg3) { { content: '<Example 3>', octets: 101 } }

    before :each do
      drop.add_message msg1
      drop.add_message msg2
      drop.add_message msg3
      lock.mark_deleted 3
    end

    it 'returns message stats' do
      expect(lock.drop_listing.to_s).to eql('2 320')
    end

    it 'returns a full scan listing' do
      listings = lock.scan_listings
      expect(listings.size).to eq(2)
      expect(listings[0].to_s).to eq('1 212')
      expect(listings[1].to_s).to eq('2 108')
    end

    it 'returns a single scan listing' do
      expect(lock.scan_listing(2).to_s).to eq('2 108')
    end

    it 'raises an error when listing a deleted message' do
      expect { lock.scan_listing 3 }.to raise_error 'no such message'
    end
  end

end
