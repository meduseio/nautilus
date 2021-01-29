module Nautilus
  module Network
    class UDPMessage
      property target : Socket::IPAddress
      property message : String
      property id : String
      property action : String

      def initialize(message : Bytes, target : Socket::IPAddress, id : String, action : String)
        @message = String.new(slice: message)
        @target = target
        @id = id
        @action = action
      end

      def initialize(message : String, target : Socket::IPAddress, id : String, action : String)
        @message = message
        @target = target
        @id = id
        @action = action
      end

      def to_s
        "SENDING MESSAGE #{action} FOR #{id} TO #{target} - #{message.to_slice}"
      end
    end
  end
end
