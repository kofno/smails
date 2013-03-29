require 'spec_helper'
require 'dannunzio/maildrops'

module Dannunzio

  describe Maildrops do

    let(:maildrops) {
      maildrops = Maildrops.new
      maildrops << Maildrop.new(username: "kofno", password: "secret")
      maildrops
    }

    it "can access maildrops by username and password" do
      maildrop = maildrops.access username: 'kofno', password: 'secret'
      expect(maildrop).to_not be_nil
    end

    it "raises an error if maildrop doesn't exist" do
      expect {
        maildrops.access username: "bogus", password: "doesn't matter"
      }.to raise_error('invalid credentials')
    end

    it "raises an error if password is incorrect" do
      expect {
        maildrops.access username: "kofno", password: "not ok"
      }.to raise_error('invalid credentials')
    end
  end

end
