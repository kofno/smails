require 'dannunzio'

module Dannunzio

  describe CommandFactory do
    let(:parser) { CommandFactory }

    it { expect(parser.parse("USER kofno")).to be_kind_of(UserCommand) }
  end
end
