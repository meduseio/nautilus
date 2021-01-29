module Nautilus
  module Cryptography
    class Manager
      property config : Nautilus::Configuration::Base
      property private_key : Sodium::CryptoBox::SecretKey
      property private_signature : Sodium::Sign::SecretKey

      def initialize(config : Nautilus::Configuration::Base)
        @config = config
        @private_key = Manager.build_private_key(config.private_node_crypto_key)
        @private_signature = Manager.build_private_signature(config.private_node_signature_key)
      end

      def self.build_id(crypt_key, signature_key)
        key = Manager.build_private_key(crypt_key)
        sign = Manager.build_private_signature(signature_key)
        Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(key.public_key.to_slice) +
                               Digest::SHA1.hexdigest(sign.public_key.to_slice))
      end

      def self.build_private_key(key) : Sodium::CryptoBox::SecretKey
        s = Nautilus::Utils::BytesToolBox.convert_hex_string_to_bytes(key)
        Sodium::CryptoBox::SecretKey.new(bytes: s.to_slice)
      end

      def self.build_private_signature(signature_key) : Sodium::Sign::SecretKey
        s = Nautilus::Utils::BytesToolBox.convert_hex_string_to_bytes(signature_key)
        Sodium::Sign::SecretKey.new(bytes: s.to_slice)
      end

      def self.new_random_signature : String
        sign_key = Sodium::Sign::SecretKey.new
        sign_key.to_slice.hexstring
      end

      def self.new_random_key : String
        priv_key = Sodium::CryptoBox::SecretKey.new
        priv_key.to_slice.hexstring
      end

      def id
        Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(public_key.to_slice) + Digest::SHA1.hexdigest(public_signature.to_slice))
      end

      def public_key
        @private_key.public_key
      end

      def public_signature
        @private_signature.public_key
      end
    end
  end
end
