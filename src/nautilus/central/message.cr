module Nautilus
  module Central
    class Message
      LOG           = 1
      GENESIS_BLOCK = 2

      def initialize(type : Int32, message : String)
        @type = type
        @message = message
      end

      def type
        @type
      end

      def message
        @message
      end
    end
  end
end
