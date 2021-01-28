module Nautilus
  module Network
    module Configuration
      class Main < Base
        def initialize
          super(["node1.nautilus.io", "node2.nautilus.io", "node3.nautilus.io"])
        end
      end
    end
  end
end
