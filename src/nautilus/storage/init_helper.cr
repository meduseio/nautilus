module Nautilus
  module Storage
    class InitHelper

      property db : DB::Database

      def initialize(db : DB::Database)
        @db = db
        create_version_table
        create_blocks
        create_accounts
        create_validators
        create_contracts_table
        create_transaction_table
      end

      def create_version_table
        exec = "CREATE TABLE IF NOT EXISTS version ( id INTEGER PRIMARY KEY,
                version INTEGER ) WITHOUT ROWID;"
         db.exec exec
      end

      def create_blocks
        exec = "CREATE TABLE IF NOT EXISTS block ( id INTEGER PRIMARY KEY,
                hash VARCHAR(64) NOT NULL, validator_id VARCHAR(40),
                reward INTEGER, parent_generation VARCHAR(64),
                timestamp TEXT NOT NULL, base_fee VARCHAR(64) NOT NULL) WITHOUT ROWID;
                CREATE UNIQUE INDEX IF NoT EXISTS block_hash ON block (hash);"
        db.exec exec
      end

      def create_accounts
        exec = "CREATE TABLE IF NOT EXISTS accounts ( address VARCHAR(42)
                PRIMARY KEY NOT NULL, balance VARCHAR(64) NOT NULL) WITHOUT ROWID;"
        db.exec exec
      end

      def create_validators
        exec = "CREATE TABLE IF NOT EXISTS validators (validator_id VARCHAR(40)
                PRIMARY KEY NOT NULL, validator_signature VARCHAR(64),
                owner_signature VARCHAR(64)) WITHOUT ROWID;

                CREATE TABLE IF NOT EXISTS validator_transaction (validator_id
                VARCHAR(40) PRIMARY KEY NOT NULL, hash VARCHAR(64) NOT NULL,
                type INTEGER, owner_signing VARCHAR(64), data TEXT,nonce INTEGER
                ) WITHOUT ROWID;


                CREATE TABLE IF NOT EXISTS validator_status (validator_id VARCHAR(40)
                PRIMARY KEY NOT NULL, hash VARCHAR(64) NOT NULL,staking_account VARCHAR(42),
                reward_account VARCHAR(42), state INTEGER, retries INTEGER, generation
                VARCHAR(64) NOT NULL, nonce INTEGER) WITHOUT ROWID;

                CREATE UNIQUE INDEX IF NoT EXISTS validators_staking ON validator_status (staking_account);
                CREATE UNIQUE INDEX IF NoT EXISTS validators_hash ON validator_status (hash);
                CREATE UNIQUE INDEX IF NoT EXISTS validators_generation ON validator_status (generation);

                CREATE TABLE IF NOT EXISTS validator_generation ( hash VARCHAR(64) PRIMARY KEY NOT NULL,
                generation VARCHAR(64) NOT NULL) WITHOUT ROWID;

                CREATE UNIQUE INDEX IF NoT EXISTS validators_generation_gen ON validator_generation (generation);"
         db.exec exec
       end

       def create_contracts_table
         exec = "CREATE TABLE IF NOT EXISTS contracts (address VARCHAR(42) PRIMARY KEY NOT NULL,
                 balance VARCHAR(64) NOT NULL, data Binary NOT NULL, interface TEXT NOT NULL ) WITHOUT ROWID;

                 CREATE TABLE IF NOT EXISTS contract_states ( identifier VARCHAR(42) PRIMARY KEY NOT NULL,
                 contract_adddress  VARCHAR(42) NOT NULL, type INTEGER, value BINARY ) WITHOUT ROWID;

                 CREATE UNIQUE INDEX IF NoT EXISTS contract_states_address_index ON contract_states (contract_adddress);"
         db.exec exec
       end

       def create_transaction_table
         exec = "CREATE TABLE IF NOT EXISTS transactions (hash VARCHAR(42) PRIMARY KEY NOT NULL,
                 block VARCHAR(42) NOT NULL, timestamp TEXT NOT NULL, source VARCHAR(42),
                 target VARCHAR(42), amount VARCHAR(64) NOT NULL, data BINARY, transaction_signature VARCHAR(64) NOT NULL,
                 base_fee_cap VARCHAR(42) NOT NULL, validator_tip VARCHAR(42) NOT NULL, fee_payer VARCHAR(42),
                 fee_payer_signature VARCHAR(64) NOT NULL, source_public_signature_key VARCHAR(128),
                 fee_payer_public_signature_key VARCHAR(128)) WITHOUT ROWID;

                 CREATE UNIQUE INDEX IF NOT EXISTS transactions_block ON transactions (block);"
       end
    end
  end
end
