module Nautilus
  module Network
    module Configuration
      class Base
        property nodes : Array(String)

        def initialize(nodes : Array(String))
          @nodes = nodes
        end


      end
    end
  end
end
