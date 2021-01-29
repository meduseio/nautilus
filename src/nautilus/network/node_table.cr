module Nautilus
  module Network
    class NodeTable
      property unresovled_nodes : Array(String)
      property table : Hash(Int32, NodeInformation)
      property id : String

      def initialize(nodes : Array(String), id : String)
        @unresovled_nodes = nodes
        @table = Hash(Int32, NodeInformation).new
        @id = id
      end

      def add_host(information : NodeInformation)
        unresovled_nodes.delete(information.ip.to_s)
        distance = Levenshtein.distance(id, information.id)
        if distance > 0
          table[distance] = information
        end
      end

      def remove_host(remote_id)
        distance = Levenshtein.distance(id, remote_id)
        if distance > 0
          table.delete(id) if table.has_key?(id)
        end
      end

      def find(remote_id : String)
        distance = Levenshtein.distance(id, remote_id)
        if distance > 0
          table[distance]
        end
      end

      def all_neighbours_for(remote_id : String)
        distance = Levenshtein.distance(id, remote_id)
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
