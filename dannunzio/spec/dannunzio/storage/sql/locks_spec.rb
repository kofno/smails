require 'spec_helper'
require 'dannunzio/storage/sql/locks'
require_relative '../shared/locks_examples'

module Dannunzio
  include SQL

  describe Locks do

    around(:each) do |example|
      Connection.connection.transaction(rollback: :always) { example.run }
    end

    it_behaves_like 'locks storage' do
      let(:locks) {
        Storage.register :locks, SQL::Locks.new
        Storage.for(:locks)
      }
      let(:maildrops) {
        Storage.register :maildrops, SQL::Maildrops.new
        Storage.for(:maildrops)
      }
    end
  end
end
