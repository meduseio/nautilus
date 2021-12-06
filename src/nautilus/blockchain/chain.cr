module Nautilus
  module Blockchain

    MIN_STAKING = "1bc16d674ec800000"

    property transaction_buffer : Array(Transaction)
    property storage : Nautilus::Storage::Database
    property config : Nautilus::Configuration::Base
    property blocksize : Int32

    class Chain
      def initialize(config : Nautilus::Configuration::Base)
        @transaction_buffer = Array(Transaction).new
        @storage = Nautilus::Storage::Database.new(config)
        @config = config
        @blocksize = 0
        read_from_db
      end

      def build_genesis
        # if @blocksize == 0
        #   block = Block.new()
        #   intial = Transaction.build_reward(@config.genesis_staking_account,
        #                                     MIN_STAKING,
        #                                     @config.private_node_signature_key)
        #   staking = Transaction.build_reward(@config.genesis_rewards_account,
        #                                      MIN_STAKING,
        #                                     @config.private_node_signature_key)
        #   block.add_transaction(intial)
        #   block.add_transaction(staking)
        # end
      end



      def read_from_db
        @blocksize = @storage.current_blocksize
      end
    end
  end
end
