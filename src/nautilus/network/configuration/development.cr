module Nautilus
  module Network
    module Configuration
      class Development < Base
        def initialize
          super(["127.0.0.1:8585"])
        end
      end
    end
  end
end
