# This is reference implementation of the Nautilus Blockchain Network
require "./nautilus/*"
require "./nautilus/central/*"
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
end

# node = Nautilus::Network::Node.new
# puts node.id
#
#
# test_text = "Das ist ein Test"
# first = Sodium::Sign::SecretKey.new
# signature = first.sign_detached(test_text)
# pub_key = String.new(slice: first.public_key.to_slice)
# address = Nautilus::Cryptography::Address.new(pub_key)
#
# puts address.is_valid?(test_text, signature)
# puts address.to_address
#
# puts [1, 5, 6].shuffle(Random::ISAAC.new(seeds: [1]))

conf = Nautilus::Configuration::Base.load

combat = Nautilus::Central::Combat.new(conf)
# spawn do
#   Nautilus::Network::Node.new(combat.channel, port).run(nodes)
# end
# test_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
# sign_key = Sodium::Sign::SecretKey.new
# puts sign_key.public_key.to_slice.size
# puts Sodium::CryptoBox::SecretKey.new.public_key.to_slice.size
# signature = sign_key.sign_detached(test_text)
# puts signature.to_slice.size
combat.run
