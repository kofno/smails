require 'dannunzio/maildrop'

module Dannunzio
  include Memory

  shared_examples "maildrops storage" do

    it "defaults to empty" do
      expect(maildrops).to be_empty
    end

    it "can append maildrops" do
      maildrops << Maildrop.new(username: 'kofno', password: 'secret')
      expect(maildrops.size).to eq(1)
    end

    it "can fetch a maildrop by name" do
      maildrops << Maildrop.new(username: 'kofno', password: 'secret')
      maildrop = maildrops.fetch_by_username('kofno')
      expect(maildrop.username).to eq('kofno')
    end

    it "returns nil when the username can't be found" do
      expect(maildrops.fetch_by_username('kofno')).to be_nil
      maildrops << Maildrop.new(username: 'not kofno', password: 'secret')
      expect(maildrops.fetch_by_username('kofno')).to be_nil
    end

  end
end
