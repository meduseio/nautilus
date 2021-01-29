module Nautilus
  module Network
    class Distance
      property point_a : Array(UInt8)

      def initialize(hash : String)
        @point_a = hash.bytes.to_a
      end

      def distance_to(hash : String)
        byte_distance(hash.bytes.to_a)
      end

      private def point_a
        @point_a
      end

      private def byte_distance(point_b : Array(UInt8))
        distance_array = Array(UInt32).new
        point_a.each_with_index { |x, i| distance_array.push(x.to_u ^ point_b[i].to_u) }
        distance_array.reduce { |acc, i| acc + i }
      end
    end
  end
end
