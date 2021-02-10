**NAUTILUS: A SECURE DECENTRALIZED CROSS-PROTOCOL GENERAL LEDGER**

TALLINN VERSION 1 – 2021-02-6

FERHAT ZIBA

CEO, MEDUSETECHNOLOGY OÜ

FOUNDER, NAUTILUS

FERHAT@MEDUSE.IO

**Abstract**

Blockchain technology has provided solutions to many different problems, just as Bitcoin has enabled cryptographically secured transactions, Ethereum has established the decentralized platform. As a number of projects, smart contracts and other blockchain technologies prove, we are at the beginning of the development of these technologies.

One important criticism of these technologies is the transaction speed and the blockchain protocol communication among each other. For two reasons it is not possible to establish a PRotocol communication between Bitcoin and Ethereum. Or, for example, the Binance Chain for decentralized trading and exchanging assets via the Blockchain in Bitcoin. This is where Nautilus comes in. And provides the base currency with its Coin MDX (Nautilus Protocol short NTL).

_ **Internal Address** _

An important key factor for communication across the various protocols is the creation, validation and verification of native Transaction. It is important that cryptographically no third party should be able to forge or otherwise manipulate a transaction and any manipulation should be detected by each participant.

To achieve this, we make use of Hierarchical Deterministic (HD) keys. Each address can be generated and verified from a master address. The structure of a master address therefore consists of a master key, protocol and a path.

_Format of the internal address:_

NATx[PUB\_ADDRESS\_HEX]:[PROTOCOL]:[PATH]

_PUB\_ADDRESS\_HEX_: The Hex representation of the public signature bytes

_PROTOCOL_ : Protocol is an Integer Value representing the protocol.

| **Number** | **Protocol** |
| --- | --- |
| 0 | Nautilus Protocol |
| 1 | Bitcoin |
| 2 | Ethereum |
| 3 | Binance Chain |
| 4 | Litecoin |
| 5 | Dodge |

_PATH :_ 6 digits Integer Value with Leading 0

From left to right every digit represents the path index. That means one internal address is limited to 10^6 keys.

010000

is the short description of

0/1/0/0/0/0

**Transaction**

Every Transaction needs enough Information to process a Transaction outside its own chain. We need to cover the risk of double spend, not processing transactions, network outages.

**Format**

TXid : Hash over the this transaction

- From
- TO
- Nonce
- value
- validator tip
- data
- payload

type :

- user transaction: A User Transaction is made by the user to process an trasaction
- validator transaction: A Validator Transaction can only made by a validator. The Validator can update transaction state.

From : internal address (String)

To : external address (Address in the format of the protocol)

nonce: the number of the transaction from the address (int)

status : [PENDING, PROCESSING, PUBLISHED, CONFIRMED, FAILED] (int8)

| **Number** | **State** | **Description** |
| --- | --- | --- |
| 0 | PENDING | A Transaction is not processed by a Validatior |
| 1 | PROCESSING | A Validator has taken this transaction for processing. |
| 2 | PUBLISHED | A transaction is published to another blockchain and waiting for confirmation
 |
| 3 | CONFIRMED | A Transaction is full confirmed on the blockchain
 |
| 4 | FAILED | A Transaction has failed.
 |

value: Amount of MDX (NTL) (as HEX STRING)

validator tip: Amount of MDX (NTL) (as HEX STRING)

data: EVM BYTECODE CODE (Compatible with Ethereum)

payload: signed third party raw blockchain transaction.

validator\_signature: Signature over the TXID + State

**BLOCK**

A Block consists of a List of transactions, a block price, previous block and transaction hash

txid: Hash

- list of transactions\_hashes
- block\_height
- block price
- timestamp
- previous block

block\_height: Hex Number

timestamp: UTC Timestamp

block\_price: Amount of MDX (NTL) (as HEX STRING)

previous\_block: Hash

validator\_signature: over the hash