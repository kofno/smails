require 'spec_helper'

module Dannunzio

  describe Maildrop do

    let(:maildrop) { Maildrop.new username: 'kofno', password: 'secret' }

    it "will verify the password for maildrop" do
      maildrop.authenticate! 'secret'
    end

    it "will lock the maildrop" do
      maildrop.save
      expect(maildrop.acquire_lock!).to be_a(Lock)
    end

    it "raises an exception if the maildrop can't be locked" do
      maildrop.save
      maildrop.acquire_lock!
      expect { maildrop.acquire_lock! }.to raise_error 'unable to lock maildrop'
    end

    it "raises an exception if a maildrop with that name can't be found" do
      expect { Maildrop.find_by_username!('who') }.to raise_error 'invalid credentials'
    end

  end

end
