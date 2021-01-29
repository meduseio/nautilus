module Nautilus
  module Network
    class NodeLogicHelper
      def self.ping_to_unresolved(node_table : NodeTable, protocol : UDPProtocol, udp_client_messages : Channel(UDPMessage))
        if node_table.unresovled_nodes.size > 0
          node_table.unresovled_nodes.each do |node|
            ip = Socket::IPAddress.new(node.split(":")[0].not_nil!, node.split(":")[1].not_nil!.to_i)
            client_message = protocol.build_ping_message(ip)
            udp_client_messages.send(client_message)
          end
        end
      end

      def self.find_neighbours(node_table : NodeTable, protocol : UDPProtocol, udp_client_messages)
        if node_table.neighbours_size < 25 && node_table.neighbours_size > 0
          node_table.neighbours.each do |information|
            client_message = protocol.build_neighbours_message(information)
            udp_client_messages.send(client_message)
          end
        end
      end
    end
  end
end
