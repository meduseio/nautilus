module Nautilus
  module Network
    module Protocol
      class Interface

        property node : NodeInformation

        def initialize(node : NodeInformation)
          @node = node
        end

        def blocksize()
          raise "Not Implemented"
        end

        def get_block(blocknumber : UInt128, partition : UInt8)
          raise "Not Implemented"
        end

        def publish_transaction(transaction : Nautilus::Blockchain::Transaction)
          raise "Not Implemented"
        end
      end
    end
  end
end