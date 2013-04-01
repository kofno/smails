module Dannunzio
  module Memory

    class Messages

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

        def delete_all(dead_messages)
          @mutex.synchronize {
            @collection.delete_if do |message|
              dead_messages.include? message
            end
          }
          self
        end

        def size
          @mutex.synchronize { @collection.size }
        end
          
      end
    end

  end
end
