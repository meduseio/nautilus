module Nautilus
  module Network
    class UDPProtocol
      PING          = [1, 1]
      PONG          = [1, 2]
      NEIGHBOURS    = [1, 3]
      NEIGHBOUR     = [1, 4]
      ARE_YOU_ALIVE = [1, 6]
      I_AM_ALIVE    = [1, 7]
      UKNOWN        = [10, 10]

      property information : NodeInformation
      property table : NodeTable

      property key : Sodium::CryptoBox::SecretKey
      property signing : Sodium::Sign::SecretKey

      def initialize(information : NodeInformation, table : NodeTable, key : Sodium::CryptoBox::SecretKey, signing : Sodium::Sign::SecretKey)
        @information = information
        @table = table
        @key = key
        @signing = signing
      end

      def handle_message(receive : String, address : Socket::IPAddress)
        message = Nautilus::Utils::BytesToolBox.convert_array_to_bytes(receive.bytes)
        protocol_action = message[0, 2]
        converted = protocol_action.to_a
        udp_messages = Array(UDPMessage).new
        begin
          if (PING <=> converted) == 0
            m_information = NodeInformation.new(message + 2, address)
            table.add_host(m_information)
            udp_messages.push(build_pong_message(m_information.ip))
          elsif (PONG <=> converted) == 0
            m_information = NodeInformation.new(message + 2, address)
            table.add_host(m_information)
          elsif (NEIGHBOURS <=> converted) == 0
            valid, remote_id = neighbours_message(message + 2)
            if valid
              neighbours = table.neighbours
              neighbours.each do |neighbour|
                next if neighbour.id == remote_id
                udp_messages.push(build_neighbour_message(neighbour, remote_id))
              end
            end
          elsif (NEIGHBOUR <=> converted) == 0
            valid, neighbour = neighbour_message(message + 2)
            if valid
              table.add_unresolved(neighbour)
            else
              puts "NEIGHBOUR NOT VALID"
            end
          end
        rescue e
          p e.inspect
        end
        udp_messages
      end

      def build_alive_message(information)
        head = Nautilus::Utils::BytesToolBox.convert_array_to_bytes(ARE_YOU_ALIVE)
        UDPMessage.new(head, information.ip, information.id, "ALIVE_MESSAGE")
      end

      def build_neighbour_message(neighbour_information : NodeInformation, remote_id : String)
        remote_information = table.find(remote_id)
        pub_key = Sodium::CryptoBox::PublicKey.new bytes: remote_information.not_nil!.public_key
        crypt_id = String.new(slice: pub_key.encrypt(information.id))
        neighbour = String.new(slice: pub_key.encrypt(neighbour_information.ip.to_s))
        signature = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(signing.sign_detached(neighbour + crypt_id))
        head = Nautilus::Utils::BytesToolBox.convert_array_to_bytes(NEIGHBOUR)

        crypt_bytes = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(crypt_id)
        neighbour = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(neighbour)
        payload = Nautilus::Utils::BytesToolBox.concat(crypt_bytes, neighbour)
        payload = Nautilus::Utils::BytesToolBox.concat(payload, signature)
        UDPMessage.new(Nautilus::Utils::BytesToolBox.concat(head, payload),
          remote_information.not_nil!.ip,
          remote_information.not_nil!.id,
          "NEIGHBOUR MESSAGE")
      end

      def neighbour_message(bytes : Bytes)
        crypted_id, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(bytes)
        crypted_neighbour, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(remaining_bytes)
        signature, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(remaining_bytes)
        valid = true
        neighbour = String.new(slice: key.decrypt(crypted_neighbour))
        remote_id = String.new(slice: key.decrypt(crypted_id))
        remote_inforamtion = table.find(remote_id)
        if remote_inforamtion != nil
          begin
            verifier = Sodium::Sign::PublicKey.new bytes: remote_inforamtion.not_nil!.public_signature
            signa_message = crypted_neighbour + crypted_id
            verifier.verify_detached signa_message.to_slice, signature.to_slice
          rescue
            valid = false
          end
        end
        {valid, neighbour}
      end

      def build_neighbours_message(node_information : NodeInformation)
        pub_key = Sodium::CryptoBox::PublicKey.new bytes: node_information.not_nil!.public_key
        crypt = pub_key.encrypt(information.id)
        signature = Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(signing.sign_detached(crypt))

        head = Nautilus::Utils::BytesToolBox.convert_array_to_bytes(NEIGHBOURS)
        payload = Nautilus::Utils::BytesToolBox.concat(Nautilus::Utils::BytesToolBox.build_unknown_message_length_bytes(crypt), signature)
        UDPMessage.new(Nautilus::Utils::BytesToolBox.concat(head, payload),
          node_information.ip,
          node_information.id,
          "NEIGHBOURS_MESSAGE")
      end

      def neighbours_message(bytes : Bytes)
        crypted_id, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(bytes)
        signature, remaining_bytes = Nautilus::Utils::BytesToolBox.read_string_from_bytes(remaining_bytes)
        valid = true
        remote_id = String.new(slice: key.decrypt(crypted_id))
        remote_inforamtion = table.find(remote_id)
        if remote_inforamtion != nil
          begin
            verifier = Sodium::Sign::PublicKey.new bytes: remote_inforamtion.not_nil!.public_signature
            verifier.verify_detached crypted_id.to_slice, signature.to_slice
          rescue
            valid = false
          end
        else
          valid = false
        end
        {valid, remote_id}
      end

      def build_ping_message(node : String)
        build_ping_message(Socket::IPAddress.parse(URI.parse(node)))
      end

      def build_ping_message(target : Socket::IPAddress)
        UDPMessage.new(Nautilus::Utils::BytesToolBox.concat(
          Nautilus::Utils::BytesToolBox.convert_array_to_bytes(PING),
          information.node_message.to_slice), target,
          "NO_ID",
          "PING MESSAGE")
      end

      def build_pong_message(node : String)
        build_pong_message(Socket::IPAddress.parse(URI.parse(node)))
      end

      def build_pong_message(target : Socket::IPAddress)
        UDPMessage.new(Nautilus::Utils::BytesToolBox.concat(
          Nautilus::Utils::BytesToolBox.convert_array_to_bytes(PONG),
          information.node_message.to_slice),
          target,
          "NO_ID",
          "PONG_MESSAGE")
      end
    end
  end
end
