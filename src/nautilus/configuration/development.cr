module Nautilus
  module Configuration
    class Development < Base
      def initialize(helper : Helper)
        s = Nautilus::Cryptography::Manager.new_random_signature
        k = Nautilus::Cryptography::Manager.new_random_key
        genesis_signature = "a9605234136abd5270adf134f5a26037d3ae94c9"
        genesis_signature = Nautilus::Cryptography::Manager.build_id(k, s) if helper.new_genesis
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
          genesis_signature,
          Path.new("~/.local", "nautilus").expand(home: true).to_s,
          helper.is_validator,
          config_file
        )
      end
    end
  end
end
