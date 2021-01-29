require "./transaction"

module Nautilus
  module Blockchain
    class Block
      def self.genesis(genesis_cypher : String, initial_deposit : Nautilus::Blockchain::Transaction, validator_depoist_transaction : Nautilus::Blockchain::Transaction, become_validator_transaction : Nautilus::Blockchain::Transaction)
        tx = [initial_deposit, validator_depoist_transaction, become_validator_transaction]
        Block.new(previous: nil, tx: tx)
      end
    end
  end
end
