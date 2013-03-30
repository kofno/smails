require 'spec_helper'

module Dannunzio

  describe CommandProcessor do

    class SampleProcessor
      include CommandProcessor

      def user arg; 'all good';end
    end

    let(:processor) { SampleProcessor.new }
    let(:parser)    { double :parser }
    let(:command)   { double :command }

    describe "processing commands" do

      it "parses and executes the command" do
        result = processor.process_command 'USER kofno'
        expect(result).to eq('all good')
      end

      it "handles unsupported commands gracefully" do
        processor.should_receive(:send_err).with('unrecognized command')
        processor.process_command "HAL 9000"
      end
    end

  end

end
