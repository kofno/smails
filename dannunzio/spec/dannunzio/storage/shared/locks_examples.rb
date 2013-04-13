
module Dannunzio
  shared_examples "locks storage" do
    let(:maildrop) {
      maildrops << Maildrop.new(username: 'kofno', password: 'secret')
      maildrops.last
    }

    it "returns nil if not locked" do
      expect(locks[maildrop]).to be_nil
    end

    it "returns the lock, if set" do
      lock = locks.create for: maildrop
      expect(locks[maildrop]).to eq(lock)
    end

    it "raises an error if seeing a lock when one already exists" do
      locks.create for: maildrop
      expect { locks.create for: maildrop }.to raise_error
    end

    it "allows the lock to be released" do
      locks.create for: maildrop
      locks.release for: maildrop
      expect(locks[maildrop]).to be_nil
    end

  end
end
