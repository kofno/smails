require 'spec_helper'

module Dannunzio
  include Memory

  describe Messages do

    let(:messages) { Storage.for(:messages) }

    it "never returns a nil" do
      expect(messages[:maildrop]).to_not be_nil
    end

    it "persists messages appeneded to the collection" do
      messages[:maildrop] << "A message"
      expect(messages[:maildrop].first).to eq("A message")
    end

    it "returns an enumerable collection" do
      expect(messages[:mailrop]).to be_a_kind_of(Enumerable)
    end

    it "returns the size of the collection" do
      messages[:maildrop] << "A message"
      expect(messages[:maildrop].size).to eq(1)
    end

    it "deletes messages based on contents of another collection" do
      messages[:maildrop] << "message 1"
      messages[:maildrop] << "message 2"
      messages[:maildrop].delete_all(["message 2"])
      expect(messages[:maildrop].size).to eq(1)
      expect(messages[:maildrop].first).to eq("message 1")
    end

    it "doesn't mix messages between maildrops" do
      messages[:maildrop1] << "message in drop 1"
      messages[:drop2]     << "message in drop 2"
      expect(messages[:maildrop1].first).to eq("message in drop 1")
      expect(messages[:maildrop1].size).to  eq(1)
    end

  end

end
