module Nautilus
  module Blockchain
    property transaction_buffer : Array(Transaction)

    class Chain
      def new(config : Nautilus::Configuration::Base)
        @transaction_buffer = Array(Transaction).new
      end
    end
  end
end
