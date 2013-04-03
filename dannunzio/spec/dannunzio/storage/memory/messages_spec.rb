require 'spec_helper'
require_relative '../shared/messages_examples'

module Dannunzio
  include Memory

  describe Messages do

    it_behaves_like "messages storage" do
      let(:messages) { Storage.for(:messages) }
    end

  end

end
