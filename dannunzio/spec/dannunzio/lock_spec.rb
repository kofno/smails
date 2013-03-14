require 'spec_helper'

module Dannunzio

  describe Lock do
    let(:drop) { Maildrop.create username: 'kofno', password: 'secret' }
    let(:lock) { drop.acquire_lock! }
    let(:msg1) { { content: '<Example 1>', octets: 212 } }
    let(:msg2) { { content: '<Example 2>', octets: 108 } }

    before :each do
      drop.add_message msg1
      drop.add_message msg2
    end

    it 'returns message stats' do
      expect(lock.message_stats.to_s).to eql('2 320')
    end
  end

end
