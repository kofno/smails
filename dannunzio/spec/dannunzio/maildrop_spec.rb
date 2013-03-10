require 'dannunzio'

module Dannunzio

  describe Maildrop do

    it "will verify the password for maildrop" do
      maildrop = Maildrop.new
      maildrop.password = 'secret'
      expect(maildrop).to be_authenticated('secret')
    end

  end

end
