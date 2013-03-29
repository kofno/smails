module Dannunzio

  class Message

    attr_reader :content, :octets

    def initialize content
      @content = content
      @octets  = content.bytesize
    end
  end

end
