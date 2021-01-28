require "uuid"
require "digest/sha1"
require "router"

module Nautilus
  module Network
    class Node
      include Router

      property information : NodeInformation
      property key : Sodium::CryptoBox::SecretKey
      property signing : Sodium::Sign::SecretKey
      property channel : Channel(Nautilus::Central::Message)
      property port : UInt32

      def initialize(channel : Channel(Nautilus::Central::Message),  port : UInt32)
        @signing = Sodium::Sign::SecretKey.new
        @key = Sodium::CryptoBox::SecretKey.new
        @nodes = Hash(UInt32, NodeInformation).new
        @port = port
        @information =  NodeInformation.new(Nautilus::Network::FORK, Nautilus::Network::VERSION, key.public_key.to_slice, signing.public_key.to_slice, @signing, port )
        @channel = channel
        message = Nautilus::Central::Message.new(Nautilus::Central::Message::LOG, "Node: #{id.to_s} started")
        channel.send(message)
        if @information.valid_node?
          message = Nautilus::Central::Message.new(Nautilus::Central::Message::LOG, "Node verification checked. all good.")
          channel.send(message)
        else
          message = Nautilus::Central::Message.new(Nautilus::Central::Message::LOG, "Node Verification is wrong.")
          channel.send(message)
          raise "INVALID NODE"
        end
        @channel = channel
      end

      def run(nodes : Array(String))
        node_table = NodeTable.new(nodes, information.id)
        protocol = UDPProtocol.new(information, node_table, key, signing)
        message = Nautilus::Central::Message.new(Nautilus::Central::Message::LOG, "Run Nodes on port: #{port}")
        channel.send(message)
        udp_client_messages = Channel(UDPMessage).new
        udp_server = UDPSocket.new
        udp_server.bind "0.0.0.0", port.to_i
        draw_routes

        Schedule.every(3.seconds) do
          begin
            if node_table.unresovled_nodes.size > 0
              node_table.unresovled_nodes.each do |node|
                ip = Socket::IPAddress.new(node.split(":")[0].not_nil!,node.split(":")[1].not_nil!.to_i  )
                client_message = protocol.build_ping_message(ip)
                udp_client_messages.send(client_message)
              end
            end
            if node_table.neighbours_size < 25 && node_table.neighbours_size > 0
              node_table.neighbours.each do |information|
                client_message = protocol.build_neighbours_message(information)
                udp_client_messages.send(client_message)
              end
            end
          rescue ex
            p ex.inspect
          end
        end

        Schedule.every(5.seconds) do
          node_table.all_neighbours_for(information.id).each do |neighbour|
            client_message =  protocol.build_alive_message(neighbour)
            udp_client_messages.send(client_message)
          end
        end

        Schedule.every(1.seconds) do
          puts "NEIGHBOURS START"
          puts node_table.print_neighbour
          puts "NEIGHBOURS END"
        end

        spawn do
          loop do
            udp_message = udp_client_messages.receive
            client = UDPSocket.new
            begin
              target = Socket::IPAddress.new(udp_message.target.address, udp_message.target.port)
              client.send udp_message.message, target
            rescue e
              p e.inspect
              node_table.remove_host(udp_message.id)
            end
            client.close
          end
        end

        spawn do
          loop do
            incomming, client_addr = udp_server.receive
            client_messages = protocol.handle_message(incomming, client_addr)
            client_messages.each do |client_message|
              udp_client_messages.send(client_message)
            end
          end
        end

        server = HTTP::Server.new(route_handler)
        server.bind_tcp port.to_i

        server.listen
      end

      def id
        @information.id
      end

      def draw_routes
        get "/hosts" do |context, params|
          context
        end

        post "/hosts" do |context, params|

          context
        end
      end

    end
  end
end
