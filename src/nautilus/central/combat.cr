module Nautilus
  module Central
    class Combat
      def initialize
        @channel = Channel(Nautilus::Central::Message).new
      end

      def channel
        @channel
      end

      def set_node_channel(node_channel : Channel(Nautilus::Central::Message))
        @node_channel = node_channel
      end

      def set_blockchain_channel(blockchain_channel : Channel(Nautilus::Central::Message))
        @blockchain_channel = blockchain_channel
      end

      def run
        loop do
          message = channel.receive
          handle(message)
        end
      end

      def handle(message : Nautilus::Central::Message)
        if message.type == Nautilus::Central::Message::LOG
          puts message.message
        end
      end
    end
  end
end
