require 'dannunzio'

module Dannunzio

  describe CommandFactory do
    let(:parser) { CommandFactory }

    it { expect(parser.parse("USER kofno")).to be_kind_of(UserCommand) }
    it { expect(parser.parse("PASS secret")).to be_kind_of(PassCommand) }
  end
end
