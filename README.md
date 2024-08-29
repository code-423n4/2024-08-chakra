# Chakra audit details

- Total Prize Pool: $60,000 in USDT
  - HM awards: $43,200 in USDT
  - QA awards: $1,800 in USDT
  - Judge awards: $4,500 in USDT
  - Validator awards: $2,500 USDT
  - Scout awards: $500 in USDT
  - Mitigation Review: 7,500 USDT (*This will be a solo mitigation review*)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts August 29, 2024 20:00 UTC
- Ends September 12, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report for `solidity/handler` can be found [here](https://github.com/code-423n4/2024-08-chakra/blob/main/4naly3er-report-handler.md).
The 4naly3er report for `solidity/settlement` can be found [here](https://github.com/code-423n4/2024-08-chakra/blob/main/4naly3er-report-settlement.md).

*Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards.*

It’s possible for Core Governance and the elections to schedule the same operation in timelocks, and therefore block each other.

# Overview

Chakra Network is the first modular settlement layer designed to unlock Bitcoin's liquidity across diverse blockchain ecosystems. 

Chakra offers a high-performance and parallelized modular settlement solution for efficient liquidity flow across Execution Layers and BTC Mainnet.

Chakra Network provides a shared settlement layer that enhances Bitcoin's integration into the broader blockchain landscape, enabling other execution layers such as L2's to focus on execution without the complexities of building settlement infrastructure.

This innovative approach unlocks interconnected liquidity and economic security, fostering a dynamic and vibrant ecosystem.

Execution layers benefit from Chakra's robust liquidity network effects, ensuring secure and scalable transaction processing. 

Chakra Network empowers Bitcoin ecosystem participants to drive growth and innovation within a safe, scalable, and interoperable framework. 

In addition, it enables DeFi projects to settle native BTC to target chains without friction, which extends the composability and utilities of their tokenized assets.

## Links

- **Previous audits:** None
- **Documentation:** <https://s3labs.notion.site/Contract-Design-Document-f4aa296f71fb40b1818c0890c40be55c?pvs=4>
- **Website:** https://chakrachain.io/home
- **X/Twitter:** https://x.com/ChakraChain
- **Discord:** https://discord.gg/chakrachain

## Scoping Q &amp; A

### General questions

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |      any             |
| Test coverage                           | 54%                         |
| ERC721 used  by the protocol            |           any           |
| ERC777 used by the protocol             |           any            |
| ERC1155 used by the protocol            |           any           |
| Chains the protocol will be deployed on | Ethereum,Base,Arbitrum,BSC,Optimism,Polygon,zkSync |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   Out of scope  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  Out of scope  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | Out of scope    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   Out of scope  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | Out of scope    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | Out of scope    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | Out of scope    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | Out of scope    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | Out of scope    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | Out of scope    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | Out of scope    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | Out of scope    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  Out of scope   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | Out of scope    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   Out of scope  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | Out of scope    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | Out of scope    |

### External integrations (e.g., Uniswap) behavior in scope

| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No   |
| Pausability (e.g. Uniswap pool gets paused)               |  Yes   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   Yes  |

### EIP compliance checklist

N/A

# Additional context

## Main invariants

- **In  Settlement Handler Contract**
  - Only the owner can add or remove handlers from the whitelist for a given chain.
  - The contract's mode (MintBurn, LockUnlock, LockMint, or BurnUnlock) is set during initialization and determines how tokens are handled during cross-chain transactions.
  - Cross-chain ERC20 settlements can only be initiated with a valid amount (greater than 0), a valid recipient address, a valid handler address, and a valid token address.
  - The nonce for each sender is incremented with each cross-chain transaction to ensure uniqueness of transaction IDs.
  - Cross-chain transaction IDs are uniquely generated based on the source and destination chain information, sender, handler addresses, and nonce.
  - Only the settlement contract can call the `receive_cross_chain_msg` and `receive_cross_chain_callback` functions.
  - The handler receiving a cross-chain message must be on the whitelist for the source chain.
  - The contract only accepts valid payload types (in this case, only ERC20 payloads).
  - The contract's behavior (minting, burning, locking, or unlocking tokens) is consistent with its initialized mode for both outgoing and incoming cross-chain transactions.
  - Cross-chain transaction statuses are properly tracked and updated (Pending, Settled, or Failed).
  - The contract ensures sufficient token balance before performing transfers, burns, or unlocks.
  - The contract uses safe transfer methods to move tokens, checking balances before transfers.
  - Only the specified token contract (set during initialization) can be used for transfers, mints, and burns within this handler.
  - The contract maintains a consistent state between locking/burning tokens on the source chain and minting/unlocking on the destination chain, depending on the settlement mode.
  - The contract uses a codec to consistently encode and decode ERC20 transfer payloads across chains.
- **In Settlement Contract**
    1. The contract can only be initialized once due to the use of the `initializer` modifier.
    2. Cross-chain transactions are uniquely identified by their `txid`, which is derived from a combination of chain names, addresses, and nonce.
    3. The nonce for each `from_address` is incremented for every new cross-chain message sent, ensuring uniqueness of transactions.
    4. Cross-chain messages can only be sent through the `send_cross_chain_msg` function, which creates a new entry in the `create_cross_txs` mapping.
    5. Received cross-chain messages are verified using signatures before being processed.
    6. A cross-chain message can only be received once. The status of a received transaction in `receive_cross_txs` must be `CrossChainMsgStatus.Unknow` before it can be processed.
    7. The status of a received cross-chain message can only transition from `Unknow` to either `Success` or `Failed`.
    8. Cross-chain callbacks can only be processed for transactions that have a `Pending` status in the `create_cross_txs` mapping.
    9. The status of a created cross-chain transaction can only transition from `Pending` to either the received status or `Failed`.
    10. Signature verification is required for both receiving cross-chain messages and cross-chain callbacks.
    11. Only valid settlement handlers can process received cross-chain messages and callbacks.
    12. The contract maintains separate mappings for created (`create_cross_txs`) and received (`receive_cross_txs`) cross-chain transactions.
    13. Events are emitted for all major cross-chain operations: message sending, message receiving, and callback processing.
    14. The contract relies on an external signature verifier (`signature_verifier`) for validating signatures.
    15. The contract inherits from `BaseSettlement`, implying it adheres to any invariants defined in that base contract.

## Attack ideas (where to focus for bugs)

None

## All trusted roles in the protocol

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Operator                          |               |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts

N/A

## Running tests

This project uses [starknet-foundry](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html) as the cairo development and testing framework.

The starknet-foundry version and scarb version used in this project are:

```
snforge 0.20.0
scarb 2.6.5
cairo: 2.6.4
``` 

To install them, use:

```bash
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
snfoundryup -v 0.20.0
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v 2.6.5
```

To clone the project and run tests, use:
```bash
git clone --recurse https://github.com/code-423n4/2024-08-chakra.git
cd 2024-08-chakra/solidity/handler
npm install
npx hardhat test
cd ../settlement
yarn
npx hardhat test
cd ../../cairo/handler
snforge test
```

*Note: some tests will fail in `solidity/settlement`. They're irrelevant.*

To run code coverage

```bash
npx hardhat coverage
```

# Scope

*See [scope.txt](https://github.com/code-423n4/2024-08-chakra/blob/main/scope.txt)*

### Files in scope

- **Cairo:** 

|File                                             |   blank     |   comment    |       code|
|-------------------------------------------------|-------------|--------------|-----------|
|cairo/handler/src/utils.cairo                    |      13     |         2    |        456|
|cairo/handler/src/settlement.cairo               |      47     |        73    |        373|
|cairo/handler/src/handler_erc20.cairo            |      32     |        27    |        209|
|cairo/handler/src/codec.cairo                    |      13     |         2    |        169|
|cairo/handler/src/ckr_btc.cairo                  |      35     |        31    |        164|
|cairo/handler/src/interfaces.cairo               |      19     |         7    |         92|
|cairo/handler/src/constant.cairo                 |       4     |         0    |         37|
|cairo/handler/src/lib.cairo                      |       0     |         2    |         10|
|SUM:                                             |     163     |       144    |       1510|

- **Solidity:**

|File                                                                     |   blank    |    comment    |       code|
|-------------------------------------------------------------------------|------------|---------------|-----------|
|solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol            |      27    |          5    |        272|
|solidity/handler/contracts/ChakraSettlementHandler.sol                   |      41    |         86    |        270|
|solidity/settlement/contracts/ChakraSettlement.sol                       |      26    |         51    |        267|
|solidity/settlement/contracts/SettlementSignatureVerifier.sol            |      22    |         80    |        113|
|solidity/handler/contracts/SettlementSignatureVerifier.sol               |      26    |          4    |        112|
|solidity/handler/contracts/BaseSettlementHandler.sol                     |      16    |         18    |        104|
|solidity/settlement/contracts/BaseSettlement.sol                         |      21    |         63    |        102|
|solidity/handler/contracts/libraries/MessageV1Codec.sol                  |      13    |          6    |         57|
|solidity/settlement/contracts/libraries/MessageV1Codec.sol               |      12    |         42    |         54|
|solidity/handler/contracts/libraries/AddressCast.sol                     |       7    |          1    |         49|
|solidity/settlement/contracts/libraries/AddressCast.sol                  |      11    |         39    |         49|
|solidity/handler/contracts/ChakraToken.sol                               |      10    |         45    |         46|
|solidity/handler/contracts/ChakraTokenUpgradeTest.sol                    |       8    |          1    |         41|
|solidity/handler/contracts/ERC20CodecV1.sol                              |       6    |         28    |         41|
|solidity/handler/contracts/TokenRoles.sol                                |       9    |          1    |         34|
|solidity/handler/contracts/libraries/Message.sol                         |       4    |         14    |         21|
|solidity/settlement/contracts/libraries/Message.sol                      |       3    |         14    |         21|
|solidity/handler/contracts/libraries/ERC20Payload.sol                    |       2    |          9    |         17|
|SUM:                                                                     |     264    |        507    |       1670|

Everything else is out of scope.

## Miscellaneous

Employees of Chakra and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.
