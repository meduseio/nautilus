module Nautilus
  module Configuration
    class Helper

      property network : String
      property nodes : Array(String)
      property is_validator : Bool
      property new_genesis : Bool
      property port : Int32
      property config_file : String

      def initialize
        @network = "main"
        @port = 8585
        @config_file = ""
        @is_validator = false
        @new_genesis = false
        @nodes = Array(String).new
        OptionParser.parse do |parser|
          parser.banner = "Usage: nautilus [options]"
          parse_network_option(parser)
          parse_node_options(parser)
          parse_validator_option(parser)
          parse_port_option(parser)
          parse_new_genesis(parser)
          parse_config_option(parser)
        end
      end

      def parse_node_options(parser)
        parser.on("-no NODE", "--node NODE", "Set first discovery Nodde") { |_node| @nodes = Array(String).new.push(_node) }
      end

      def parse_validator_option(parser)
        parser.on("-v", "--validator", "Enable validator") { @is_validator = true }
      end

      def parse_port_option(parser)
        parser.on("-p PORT", "--port PORT", "Enable validator") { |_port| @port = _port.to_i }
      end

      def parse_config_option(parser)
          parser.on("-c CONFIG_FILE", "--config=CONFIG_FILE", "Select the network") { |_config| @config_file = _config.to_s }
      end

      def parse_network_option(parser)
        parser.on("-n NETWORK", "--network=NETWORK", "Select the network") { |_network| @network = _network }
      end

      def parse_new_genesis(parser)
        parser.on("-g", "--enable_genesis", "This node will be the genesis validattor") { @new_genesis = true }
      end

    end
  end
end
