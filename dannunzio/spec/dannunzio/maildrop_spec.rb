require 'spec_helper'

module Dannunzio

  describe Maildrop do

    let(:maildrop) { Maildrop.new username: 'kofno', password: 'secret' }

    it "will verify the password for maildrop" do
      maildrop.authenticate! 'secret'
    end

    it "will lock the maildrop" do
      maildrop.save
      expect(maildrop.lock!).to be_a(Lock)
    end

    it "raises an exception if the maildrop can't be locked" do
      maildrop.save
      maildrop.lock!
      expect { maildrop.lock! }.to raise_error 'unable to lock maildrop'
    end

  end

end
