require 'dannunzio'

module Dannunzio

  describe Store do
    let(:store) { Store.new }

    it 'fetches maildrops by username' do
      Maildrop.should_receive(:find).with username: 'kofno'
      store.fetch_maildrop 'kofno'
    end
  end
end
