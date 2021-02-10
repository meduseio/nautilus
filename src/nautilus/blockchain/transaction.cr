module Nautilus
  module Blockchain
    class Transaction

      property source : String
      property source_pub_signature : String
      property target : String
      property amount : String
      property data : String
      property fee_payer : String
      property fee_payer_pub_signature : String
      property base_fee_cap : String
      property validator_tip : String

      def initialize(source : String,
                     source_pub_signature : String,
                     target : String,
                     amount : String,
                     data : String,
                     fee_payer : String,
                     fee_payer_pub_signature : String,
                     base_fee_cap : String,
                     validator_tip : String)
        @source = source
        @target = target
        @source_pub_signature = source_pub_signature
        @amount = amount
        @data = data
        @fee_payer = fee_payer
        @fee_payer_pub_signature = fee_payer_pub_signature
        @base_fee_cap = base_fee_cap
        @validator_tip = validator_tip
        @transaction_signature = ""
        @fee_signature = ""

      end

      def build_main_transaction
        Digest::SHA1.hexdigest(source + target + amount + data)
      end

      def set_transaction_signature(transaction_signature : String)
        @transaction_signature = transaction_signature
      end

      def transaction_signature() : String
        @transaction_signature
      end

      def build_fee_transaction
        Digest::SHA1.hexdigest(transaction_signature() + fee_payer + base_fee_cap + validator_tip)
      end

      def set_fee_signature(fee_signature : String)
        @fee_signature = fee_signature
      end

      def fee_signature() : String
        @fee_signature
      end

      def valid?
        transaction_pub_key = Sodium::Sign::PublicKey.new bytes: Nautilus::Utils::BytesToolBox.convert_hex_string_to_bytes(source_pub_signature)
        fee_pub_key = Sodium::Sign::PublicKey.new bytes: Nautilus::Utils::BytesToolBox.convert_hex_string_to_bytes(fee_payer_pub_signature)
        is_valid_signature?(node_sign, build_main_transaction, transaction_pub_key) &&
        is_valid_signature?(node_sign, build_fee_transaction, @fee_signature)
      end

      private def is_valid_signature?

      end

      def is_reward?
        source == data == fee_payer == base_fee_cap == validator_tip ==  "0x"
      end

    end
  end
end
