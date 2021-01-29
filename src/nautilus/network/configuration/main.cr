module Nautilus
  module Network
    module Configuration
      class Main < Base
        def initialize(genesis = false)
          s = Nautilus::Cryptography::Manager.new_random_signature
          k = Nautilus::Cryptography::Manager.new_random_key
          genesis_signature = "e2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
          genesis_signature = Nautilus::Cryptography::Manager.build_id(k, s) if genesis
          super(
            "main",
            UInt32.new(8585),
            ["node1.nautilus.io", "node2.nautilus.io", "node3.nautilus.io"],
            {0 => 10, 15_000_000 => 7, 90_000_000 => 5},
            {0 => 4, 3_000_000 => 3, 6_000_000 => 2, 9_000_000 => 1, 12_000_000 => 0},
            10,
            s,
            k,
            2,
            2,
            100,
            genesis_signature,
            Path.new("~/.local","nautilus").expand(home: true).to_s,
            false
          )
        end
      end
    end
  end
end
