require 'spec_helper'
require_relative '../shared/maildrops_examples'

module Dannunzio
  include Memory

  describe Maildrops do

    it_behaves_like "maildrops storage" do
      let(:maildrops) { Storage.for(:maildrops) }
    end

  end
end
