require "socket"

module Nautilus
  module Network
    class NodeInformation
      property version : UInt8
      property network_fork : UInt8
      property public_signature  : Bytes
      property public_key : Bytes
      property ip : Socket::IPAddress
      property signature : Bytes
      property id : String
      property port : UInt32

      def initialize(network_fork : UInt8, version : UInt8, public_key_bytes : Bytes, public_signature_bytes : Bytes, signing : Sodium::Sign::SecretKey, port : UInt32)
        @version = version
        @network_fork = network_fork
        @public_signature = public_signature_bytes
        @public_key = public_key_bytes
        @ip = Socket::IPAddress.new("127.0.0.1", port.to_i)
        @id = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@public_key.to_slice) + Digest::SHA1.hexdigest(@public_signature.to_slice))
        @port = port
        @signature = signing.sign_detached(@id).to_slice
      end

      def initialize(bytes : Bytes, ip : Socket::IPAddress)
        @network_fork = bytes[0]
        @version = bytes[1]
        remaining_bytes = bytes + 2
        public_key_string, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(remaining_bytes)
        @public_key = public_key_string.to_slice
        public_signature_string, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(remaining_bytes)
        @public_signature = public_signature_string.to_slice
        signature_bytes, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(remaining_bytes)
        @signature = signature_bytes.to_slice
        @port = Nautilus::Utils::BytesToolBox.convert_bytes_to_uint32(remaining_bytes).to_u
        @ip = Socket::IPAddress.new(ip.address, @port.to_i)
        @id = Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(@public_key.to_slice) + Digest::SHA1.hexdigest(@public_signature.to_slice))
      end

      def node_message
        head = Bytes.new(2)
        head[0] = network_fork;
        head[1] = version
        public_key_bytes = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(String.new(slice: public_key))
        public_signature_bytes = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(String.new(slice: public_signature))
        signature_bytes = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(String.new(slice: signature))
        port_bytes = Nautilus::Utils::BytesToolBox.convert_uint32_to_bytes(@port)
        pub_keys = concat(public_key_bytes, public_signature_bytes)
        payload = concat(concat(pub_keys, signature_bytes), port_bytes)
        String.new(slice: concat(head, payload))
      end

      def valid_node?
        key = Sodium::Sign::PublicKey.new bytes: public_signature
        key.verify_detached id, signature
        true
      rescue
        false
      end

      private def concat(a : Bytes, b : Bytes)
        result = IO::Memory.new a.bytesize + b.bytesize
        a.each do |v|
            result.write_bytes UInt8.new v
        end
        b.each do |v|
            result.write_bytes UInt8.new v
        end
        result.to_slice
      end
    end
  end
end
