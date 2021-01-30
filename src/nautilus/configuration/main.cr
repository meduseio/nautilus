module Nautilus
  module Configuration
    class Main < Base
      def initialize(helper : Helper)
        s = Nautilus::Cryptography::Manager.new_random_signature
        k = Nautilus::Cryptography::Manager.new_random_key
        genesis_validator = "e2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
        genesis_signature = "SOME_STRING"
        genesis_staking_account = "Nxe2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
        genesis_rewards_account = "Nxe2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
        if helper.new_genesis
          genesis_validator = Nautilus::Cryptography::Manager.build_id(k, s) if helper.new_genesis
          genesis_signature = Nautilus::Cryptography::Manager.build_public_signature_hexstring_from_private_key(s)
        end
        config_file = "config.yml"
        config_file = helper.config_file if helper.config_file.size > 0
        super(
          "main",
          helper.port,
          ["node1.nautilus.io", "node2.nautilus.io", "node3.nautilus.io"],
          {0 => 10, 15_000_000 => 7, 90_000_000 => 5},
          {0 => 4, 3_000_000 => 3, 6_000_000 => 2, 9_000_000 => 1, 12_000_000 => 0},
          10,
          s,
          k,
          2,
          2,
          100,
          genesis_validator,
          genesis_signature,
          genesis_staking_account,
          genesis_rewards_account,
          Path.new("~/.local", "nautilus").expand(home: true).to_s,
          helper.is_validator,
          config_file
        )
      end
    end
  end
end
