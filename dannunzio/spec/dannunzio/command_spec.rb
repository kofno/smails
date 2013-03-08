require 'dannunzio'

module Dannunzio

  describe Command do
    let(:mode)    { double :mode }
    let(:command) { Command.new "Doesn't matter" }

    it "executes the subclass's behavior" do
      command.should_receive(:call)
      command.execute mode
    end
    
    it "treats dispatch errors as unsupported commands" do
      command.should_receive(:call).and_raise NoMethodError
      expect { command.execute mode }.to raise_error(UnsupportedCommand)
    end
  end
end
