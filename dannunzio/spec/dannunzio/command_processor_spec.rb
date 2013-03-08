require 'dannunzio'

module Dannunzio

  describe CommandProcessor do

    class SampleProcessor
      include CommandProcessor
    end

    let(:processor) { SampleProcessor.new }
    let(:parser)    { double :parser }
    let(:command)   { double :command }

    describe "processing commands" do

      it "parses and executes the command" do
        processor.should_receive(:parser).and_return parser
        parser.should_receive(:parse).with('USER kofno').and_return command
        command.should_receive(:execute).with processor

        processor.process_command 'USER kofno'
      end

      it "handles unsupported commands gracefully" do
        processor.should_receive(:parser).and_return parser
        parser.should_receive(:parse).and_raise UnsupportedCommand
        processor.should_receive(:unsupported_command)

        processor.process_command "HAL 9000"
      end
    end

  end

end
