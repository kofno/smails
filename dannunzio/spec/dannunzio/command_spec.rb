require 'spec_helper'

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

    describe UserCommand do
      let(:user) { UserCommand.new "USER kofno" }

      it "executes command in the proper mode" do
        user.should_receive(:mode).and_return mode
        mode.should_receive(:user).with "kofno"

        user.call
      end
    end

    describe PassCommand do
      let(:pass) { PassCommand.new "PASS my voice is my passport" }

      it "executes the command with proper arguments" do
        pass.should_receive(:mode).and_return mode
        mode.should_receive(:pass).with "my voice is my passport"

        pass.call
      end
    end
  end

end
