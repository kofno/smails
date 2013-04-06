require 'spec_helper'
require 'dannunzio/storage/sql/maildrops'
require_relative '../shared/maildrops_examples'

module Dannunzio
  include SQL

  describe Maildrops do

    around(:each) do |example|
      Connection.connection.transaction(rollback: :always) { example.run }
    end

    it_behaves_like 'maildrops storage' do
      let(:maildrops) {
        Storage.register :maildrops, SQL::Maildrops.new
        Storage.for :maildrops
      }
    end
  end
end
