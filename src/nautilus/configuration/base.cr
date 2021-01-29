module Nautilus
  module Configuration
    class Base
      property network : String
      property port : Int32
      property nodes : Array(String)
      property rewards : Hash(Int32, Int32)
      property proof_of_work : Hash(Int32, Int32)
      property time_to_next_block : Int32
      property private_node_signature_key : String
      property private_node_crypto_key : String
      property neighbour_size : Int32
      property max_number_of_validators : Int32
      property number_of_blocks_in_generation : Int32
      property genesis_validator : String
      property working_direcotry : String
      property is_validator : Bool

      def self.load
        helper = Helper.new()
        if helper.network == "development"
          Development.new(helper)
        else
          Main.new(helper)
        end
      end

      def initialize(
        network : String,
        port : Int32,
        nodes : Array(String),
        rewards : Hash(Int32, Int32),
        proof_of_work : Hash(Int32, Int32),
        time_to_next_block : Int32,
        private_node_signature_key : String,
        private_node_crypto_key : String,
        neighbour_size : Int32,
        max_number_of_validators : Int32,
        number_of_blocks_in_generation : Int32,
        genesis_validator : String,
        working_direcotry : String,
        is_validator : Bool,
        config_file : String
      )
        @network = network
        @port = port
        @nodes = nodes
        @rewards = rewards
        @proof_of_work = proof_of_work
        @time_to_next_block = time_to_next_block
        @private_node_signature_key = private_node_signature_key
        @private_node_crypto_key = private_node_crypto_key
        @neighbour_size = neighbour_size
        @max_number_of_validators = max_number_of_validators
        @number_of_blocks_in_generation = number_of_blocks_in_generation
        @genesis_validator = genesis_validator
        @working_direcotry = working_direcotry
        @is_validator = is_validator
        @config_file = config_file
        read_from_config_file unless write_config_file
      end

      def read_from_config_file
        json_as_string = File.read(@config_file)
        values = JSON.parse(json_as_string)
        @time_to_next_block = values["time_to_next_block"].as_i
        @nodes = Array(String).new
        values["nodes"].as_a.each do |node|
          @nodes.push(node.to_s)
        end
        @rewards = Hash(Int32, Int32).new
        values["rewards"].as_a.each do |reward|
          @rewards[reward["starting_block"].as_i] = reward["reward"].as_i
        end
        @proof_of_work = Hash(Int32, Int32).new
        values["proof_of_work"].as_a.each do |entry|
          @proof_of_work[entry["starting_block"].as_i] = entry["zeros"].as_i
        end
        @private_node_signature_key = values["private_node_signature_key"].to_s
        @private_node_crypto_key = values["private_node_crypto_key"].to_s
        @neighbour_size = values["neighbour_size"].as_i
        @max_number_of_validators = values["max_number_of_validators"].as_i
        @number_of_blocks_in_generation = values["number_of_blocks_in_generation"].as_i
        @genesis_validator = values["number_of_blocks_in_generation"].to_s
        @working_direcotry = values["working_direcotry"].to_s
        @is_validator = values["is_validator"].as_bool
      end

      def write_config_file
        puts "Working directory : #{working_direcotry}"
        Dir.mkdir_p(working_direcotry) unless File.exists? working_direcotry
        FileUtils.cd(working_direcotry)
        Dir.mkdir(network) unless File.exists? network
        FileUtils.cd(network)
        return false if File.exists? @config_file
        json_config = build_json_config
        File.write(@config_file, json_config) unless File.exists? @config_file
      end

      def build_json_config : String
        JSON.build(2) do |json|
          json.object do
            json.field "time_to_next_block", time_to_next_block
            json.field "nodes" do
              json.array do
                nodes.each { |node| json.string node }
              end
            end
            json.field "rewards" do
              json.array do
                rewards.keys.each do |k|
                  json.object do
                    json.field "starting_block", k
                    json.field "reward", rewards[k]
                  end
                end
              end
            end
            json.field "proof_of_work" do
              json.array do
                rewards.keys.each do |k|
                  json.object do
                    json.field "starting_block", k
                    json.field "zeros", rewards[k]
                  end
                end
              end
            end
            json.field "private_node_signature_key", private_node_signature_key
            json.field "private_node_crypto_key", private_node_crypto_key
            json.field "neighbour_size", neighbour_size
            json.field "max_number_of_validators", max_number_of_validators
            json.field "number_of_blocks_in_generation", number_of_blocks_in_generation
            json.field "genesis_validator", genesis_validator
            json.field "working_direcotry", working_direcotry
            json.field "is_validator", is_validator
          end
        end
      end
    end
  end
end
