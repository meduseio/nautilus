# nautilus

This is the crystal lang implementation of the Nautilus Blockchain Protocol. 
Its still in development : **[Read the Protocol Documentation.](https://github.com/MeduseIO/nautilus/blob/master/doc/protocol.md)**

## Installation
Dependencies:
**[Crystal lang.](https://github.com/crystal-lang/crystal)**

cd to the repository folder and run:

```zsh
shards build
```

All Binaries are in the bin folder of this repository.

## Usage

Currently only development Network is implemented. Run first Node:

```zsh
bin/nautilus --network=development
```

The Genesis Node, need to be setup first, its not possible build the first block without the genesis node.

## TODO

- Command Line Tool for creating and managing Accounts
- Command Line Tool for access to the node through RPC.
- Setup procedure for Genesis Node (Required for development mode)
- Enable Validation Model
- Add EVM to be binary compatible with Ethereum.
- Add Clients for other Network Protocols for Validation
- Write more Documentation

## Contributing

1. Fork it (<https://github.com/your-github-user/nautilus/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ferhat Ziba](https://github.com/fero46) - creator and maintainer
