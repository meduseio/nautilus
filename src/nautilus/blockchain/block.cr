require "./transaction"

module Nautilus
  module Blockchain
    class Block

      property transactions : Array(Nautilus::Blockchain::Transaction)

      def initialize
        @transactions = Array(Nautilus::Blockchain::Transaction).new
      end

      def add_transaction(transaction : Nautilus::Blockchain::Transaction)
        @transactions.push(transaction)
      end

      
    end
  end
end
