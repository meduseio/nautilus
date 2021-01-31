module Nautilus
  module Cryptography
    class Address
      property address : String

      def initialize(pub_key : String)
        @key = Sodium::Sign::PublicKey.new bytes: pub_key.to_slice
        address = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(pub_key) + Digest::SHA1.hexdigest(pub_key)).to_s
        @address = "Nx" + address
      end

      def is_valid?(message, signature)
        @key.verify_detached message, signature
        true
      rescue
        false
      end

      def to_address
        @address
      end
    end
  end
end
