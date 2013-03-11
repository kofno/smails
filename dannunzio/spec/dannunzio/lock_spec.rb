require 'spec_helper'

module Dannunzio

  describe Lock do

    it 'returns message stats' do
      expect(lock.message_stats.to_s).to eql('2 320')
    end
  end

end
