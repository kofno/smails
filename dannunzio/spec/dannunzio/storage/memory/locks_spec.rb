require 'spec_helper'

module Dannunzio
  include Memory

  describe Locks do

    let(:locks) { Storage.for(:locks) }

    it "returns nil if not locked" do
      expect(locks[:maildrop]).to be_nil
    end

    it "returns the lock, if set" do
      locks[:maildrop] = :lock
      expect(locks[:maildrop]).to eq(:lock)
    end

    it "raises an error if setting a lock when one already exists" do
      locks[:maildrop] = :lock
      expect { locks[:maildrop] = :lock }.to raise_error(LockAlreadyExists)
    end

    it "allows the lock to be released" do
      locks[:maildrop] = :lock
      locks[:maildrop] = nil
      expect(locks[:maildrop]).to be_nil
    end

  end

end
