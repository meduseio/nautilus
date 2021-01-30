module Nautilus
  module Blockchain

    MIN_STAKING = "1bc16d674ec800000"

    property transaction_buffer : Array(Transaction)
    property storage : Nautilus::Storage::Database
    property config : Nautilus::Configuration::Base

    class Chain
      def initialize(config : Nautilus::Configuration::Base)
        @transaction_buffer = Array(Transaction).new
        @storage = Nautilus::Storage::Database.new(config)
        read_from_db
      end

      def build_genesis
        if @blocksize == 0
          
          intial = Transaction.build_reward(config.genesis_staking_account,MIN_STAKING,
              conf.private_node_signature_key)
          staking = Transaction.build_reward(config.genesis_rewards_account,MIN_STAKING,
              conf.private_node_signature_key)

        end
      end



      def read_from_db
        @blocksize = @storage.current_blocksize
      end
    end
  end
end
