module Nautilus
  module Central
    class Message
      LOG = 1

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
