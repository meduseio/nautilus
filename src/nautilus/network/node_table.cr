module Nautilus
  module Network
    class NodeTable
      property unresovled_nodes : Array(String)
      property distance_helper : Distance
      property table : Hash(UInt32, NodeInformation)

      def initialize(nodes : Array(String), id : String)
        @unresovled_nodes = nodes
        @distance_helper = Distance.new(id)
        @table = Hash(UInt32, NodeInformation).new
      end

      def add_host(information : NodeInformation)
        unresovled_nodes.delete(information.ip.to_s)
        distance = distance_helper.distance_to(information.id)
        if distance > 0
          table[distance] = information
        end
      end

      def remove_host(id)
        distance = distance_helper.distance_to(id)
        if distance > 0
          table.delete(id) if table.has_key?(id)
        end
      end

      def find(id : String)
        distance = distance_helper.distance_to(id)
        if distance > 0
          table[distance]
        end
      end

      def all_neighbours_for(id : String)
        distance = distance_helper.distance_to(id)
        result = Array(NodeInformation).new
        if table.size > 0
          keys = table.keys.dup.sort
          keys.delete(distance)
          keys.each do |key|
            result.push(table[key])
          end
        end
        result
      end

      def remove_unresolved(node)
        unresovled_nodes.delete(node)
      end

      def add_unresolved(node)
        unresovled_nodes.push(node)
      end

      def neighbours_size
        table.size
      end

      def neighbours
        table.values.dup
      end

      def print_neighbour
        keys = table.keys.sort
        keys.each do |key|
          information = table[key]
          puts information.id
        end
      end
    end
  end
end
