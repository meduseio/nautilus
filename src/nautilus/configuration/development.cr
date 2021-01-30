module Nautilus
  module Configuration
    class Development < Base
      def initialize(helper : Helper)
        s = Nautilus::Cryptography::Manager.new_random_signature
        k = Nautilus::Cryptography::Manager.new_random_key
        genesis_validator = "039c059a8b8b91c40158729076a793542af096a2"
        genesis_signature = "ca321a0a60ab256711e09ff74342023a2f971ad1e79a2874511962eff6ccc022"
        genesis_staking_account = "Nxe2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
        genesis_rewards_account = "Nxe2a5cf93eb9d96d05f8e06bcc1b3c0ad5a9ca85c"
        if helper.new_genesis
          genesis_validator = Nautilus::Cryptography::Manager.build_id(k, s)
          genesis_signature = Nautilus::Cryptography::Manager.build_public_signature_hexstring_from_private_key(s)
        end
        config_file = "config.yml"
        config_file = helper.config_file if helper.config_file.size > 0
        super(
          "development",
          helper.port,
          ["127.0.0.1:8585"],
          {0 => 5, 1000 => 3},
          {0 => 4, 1000 => 3, 2000 => 2, 3000 => 1, 4000 => 0},
          60,
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
