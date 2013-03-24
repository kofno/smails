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

      it "treats all arguments as one whitespaced password" do
        pass.should_receive(:mode).and_return mode
        mode.should_receive(:pass).with "my voice is my passport"

        pass.call
      end

      it "removes trailing new lines" do
        pass = PassCommand.new "PASS secret\r\n"
        pass.should_receive(:mode).and_return mode
        mode.should_receive(:pass).with "secret"

        pass.call
      end
    end

    describe ListCommand do
      it "calls the proper list command for no argument version" do
        list = ListCommand.new "LIST"
        list.should_receive(:mode).and_return mode
        mode.should_receive(:list_all).with(no_args)

        list.call
      end
    end
  end

end
