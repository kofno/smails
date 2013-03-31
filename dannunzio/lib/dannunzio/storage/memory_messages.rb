module Dannunzio

  class MemoryMessages

    def [](key)
      Storage::MUTEX.synchronize { messages[key] }
    end

    private

    def messages
      @messages ||= Hash.new { |hash, key|
        hash[key] = MessagesCollection.new
      }
    end

    class MessagesCollection

      include Enumerable

      def initialize
        @collection = []
        @mutex = Mutex.new
      end

      def <<(thing)
        @mutex.synchronize { @collection << thing }
      end

      def each(&block)
        @mutex.synchronize {
          @collection.each(&block)
        }
        self
      end

      def delete_if(&block)
        @mutex.synchronize {
          @collection.delete_if &block
        }
        self
      end

      def size
        @mutex.synchronize { @collection.size }
      end
        
    end
  end

end
