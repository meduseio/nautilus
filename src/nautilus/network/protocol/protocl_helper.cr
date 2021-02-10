module Nautilus
  module Network
    module Protocol
      class ProtocolHelper
        SUPPORTED_PROTOCOL = ["v1"]
        PROTOCOL_MAPPING = { "v1": Nautilus::Network::Protocol::ProtocolVersion1 }

        def translator(protocl) : Nautilus::Network::Protocol::Interface

        end
        
      end
    end
  end
end