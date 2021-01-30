module Nautilus
  module Blockchain
    class Transaction

      property source : String
      property target : String
      property amount : String
      property data : String
      property fee_payer : String
      property base_fee_cap : String
      property validator_tip : String

      def self.build_reward(account : String, amount : String, signature_key : String)
        sign_key = Nautilus::Cryptography::Manager.build_private_signature(signature_key)
        t = Transaction.new("0x", account, amount, "0x", "0x", "0x", "0x")
        main_hash = t.build_main_transaction
        transaction_signature = String.new(slice: sign_key.sign_detached(main_hash))
        t.set_transaction_signature(transaction_signature)
        fee_hash = t.build_fee_transaction
        fee_signature = String.new(slice: sign_key.sign_detached(main_hash))
        t.set_fee_signature(fee_signature)
        t
      end

      def initialize(source : String, target : String, amount : String, data : String, fee_payer : String, base_fee_cap : String, validator_tip : String)
        @source = source
        @target = target
        @amount = amount
        @data = data
        @base_fee_cap = base_fee_cap
        @validator_tip = validator_tip
      end

      def build_main_transaction
        Digest::SHA1.hexdigest(source + target + amount + data)
      end

      def set_transaction_signature(transaction_signature)
        @transaction_signature
      end

      def transaction_signature
        @transaction_signature
      end

      def build_fee_transaction
        Digest::SHA1.hexdigest(@transaction_signature + fee_payer + base_fee_cap + validator_tip)
      end

      def set_fee_signature(fee_signature)
        @fee_signature = fee_signature
      end

      def valid?
        if is_reward?
          node_sign = Sodium::Sign::PublicKey.new bytes: Nautilus::Utils::BytesToolBox.convert_hex_string_to_bytes(signature_hexstring)
          is_valid_signature?(node_sign, build_main_transaction, @transaction_signature) &&
          is_valid_signature?(node_sign, build_fee_transaction, @fee_signature)
        else
          valid?
        end
      end

      private def valid?

      end

      def is_valid_signature?(key : Sodium::Sign::PublicKey, message : String, signature : String)
        key.verify_detached message, signature.to_slice
        true
      rescue
        false
      end

      def is_reward?
        source == data == fee_payer == base_fee_cap == validator_tip ==  "0x"
      end

    end
  end
end
