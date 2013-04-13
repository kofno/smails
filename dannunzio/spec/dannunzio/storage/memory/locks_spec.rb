require 'spec_helper'
require_relative '../shared/locks_examples'

module Dannunzio
  include Memory

  describe Locks do

    it_behaves_like "locks storage" do
      let(:locks) { Storage.for(:locks) }
      let(:maildrops) { Storage.for(:maildrops) }
    end

  end

end
