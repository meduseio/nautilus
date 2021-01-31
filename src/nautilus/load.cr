require "./api/*"
require "./blockchain/*"
require "./central/*"
require "./central/*"
require "./configuration/*"
require "./cryptography/*"
require "./network/*"
require "./storage/*"
require "./utils/*"
require "db"
require "db/database"
require "sqlite3"
require "sodium"
require "base64"
require "openssl"
require "random/isaac"
require "option_parser"
require "json"
require "http/client"
require "socket"
require "schedule"
require "system/user"
require "file_utils"
require "levenshtein"

module Nautilus
  VERSION = "0.1.0"
  module Blockchain
    REWARDS = 5
  end
  module Network
    VERSION = UInt8.new(1)
    FORK    = UInt8.new(1)
  end
end
