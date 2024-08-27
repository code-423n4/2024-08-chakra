# ✨ So you want to run an audit

This `README.md` contains a set of checklists for our audit collaboration.

Your audit will use two repos: 
- **an _audit_ repo** (this one), which is used for scoping your audit and for providing information to wardens
- **a _findings_ repo**, where issues are submitted (shared with you after the audit) 

Ultimately, when we launch the audit, this repo will be made public and will contain the smart contracts to be reviewed and all the information needed for audit participants. The findings repo will be made public after the audit report is published and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the audit sponsor (⭐️)**.

---

# Audit setup

## 🐺 C4: Set up repos
- [ ] Create a new private repo named `YYYY-MM-sponsorname` using this repo as a template.
- [ ] Rename this repo to reflect audit date (if applicable)
- [ ] Rename audit H1 below
- [ ] Update pot sizes
  - [ ] Remove the "Bot race findings opt out" section if there's no bot race.
- [ ] Fill in start and end times in audit bullets below
- [ ] Add link to submission form in audit details below
- [ ] Add the information from the scoping form to the "Scoping Details" section at the bottom of this readme.
- [ ] Add matching info to the Code4rena site
- [ ] Add sponsor to this private repo with 'maintain' level access.
- [ ] Send the sponsor contact the url for this repo to follow the instructions below and add contracts here. 
- [ ] Delete this checklist.

# Repo setup

## ⭐️ Sponsor: Add code to this repo

- [ ] Create a PR to this repo with the below changes:
- [ ] Confirm that this repo is a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 48 business hours prior to audit start time.**
- [ ] Be prepared for a 🚨code freeze🚨 for the duration of the audit — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the audit. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)

## ⭐️ Sponsor: Repo checklist

- [ ] Modify the [Overview](#overview) section of this `README.md` file. Describe how your code is supposed to work with links to any relevent documentation and any other criteria/details that the auditors should keep in mind when reviewing. (Here are two well-constructed examples: [Ajna Protocol](https://github.com/code-423n4/2023-05-ajna) and [Maia DAO Ecosystem](https://github.com/code-423n4/2023-05-maia))
- [ ] Review the Gas award pool amount, if applicable. This can be adjusted up or down, based on your preference - just flag it for Code4rena staff so we can update the pool totals across all comms channels.
- [ ] Optional: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] [This checklist in Notion](https://code4rena.notion.site/Key-info-for-Code4rena-sponsors-f60764c4c4574bbf8e7a6dbd72cc49b4#0cafa01e6201462e9f78677a39e09746) provides some best practices for Code4rena audit repos.

## ⭐️ Sponsor: Final touches
- [ ] Review and confirm the pull request created by the Scout (technical reviewer) who was assigned to your contest. *Note: any files not listed as "in scope" will be considered out of scope for the purposes of judging, even if the file will be part of the deployed contracts.*
- [ ] Check that images and other files used in this README have been uploaded to the repo as a file and then linked in the README using absolute path (e.g. `https://github.com/code-423n4/yourrepo-url/filepath.png`)
- [ ] Ensure that *all* links and image/file paths in this README use absolute paths, not relative paths
- [ ] Check that all README information is in markdown format (HTML does not render on Code4rena.com)
- [ ] Delete this checklist and all text above the line below when you're ready.

---

# Chakra audit details
- Total Prize Pool: $67,500 in USDC
  - HM awards: $49,450 in USDC
  - QA awards: $2,050 in USDC
  - Judge awards: $5,000 in USDC
  - Validator awards: 3,000 USDC 
  - Scout awards: $500 in USDC
  - Mitigation Review: $7,500 in USDC (*Opportunity goes to top 3 backstage wardens based on placement in this audit who RSVP.*)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts August 28, 2024 20:00 UTC
- Ends September 11, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-08-chakra/blob/main/4naly3er-report.md).

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

It’s possible for Core Governance and the elections to schedule the same operation in timelocks, and therefore block each other. 

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

# Overview

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:**  
  - ✅ SCOUTS: If there are multiple report links, please format them in a list.
- **Documentation:** https://s3labs.notion.site/Contract-Design-Document-f4aa296f71fb40b1818c0890c40be55c?pvs=4
- **Website:** 🐺 CA: add a link to the sponsor's website
- **X/Twitter:** 🐺 CA: add a link to the sponsor's Twitter
- **Discord:** 🐺 CA: add a link to the sponsor's Discord

---

# Scope

[ ✅ SCOUTS: add scoping and technical details here ]

### Files in scope
- ✅ This should be completed using the `metrics.md` file
- ✅ Last row of the table should be Total: SLOC
- ✅ SCOUTS: Have the sponsor review and and confirm in text the details in the section titled "Scoping Q amp; A"

*For sponsors that don't use the scoping tool: list all files in scope in the table below (along with hyperlinks) -- and feel free to add notes to emphasize areas of focus.*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

### Files out of scope
✅ SCOUTS: List files/directories out of scope

## Scoping Q &amp; A

### General questions
### Are there any ERC20's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

Any (all possible ERC20s)


### Are there any ERC777's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

any

### Are there any ERC721's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

any

### Are there any ERC1155's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

anty

✅ SCOUTS: Once done populating the table below, please remove all the Q/A data above.

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       🖊️             |
| Test coverage                           | ✅ SCOUTS: Please populate this after running the test coverage command                          |
| ERC721 used  by the protocol            |            🖊️              |
| ERC777 used by the protocol             |           🖊️                |
| ERC1155 used by the protocol            |              🖊️            |
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

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No   |
| Pausability (e.g. Uniswap pool gets paused)               |  Yes   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   Yes  |


### EIP compliance checklist
N/A

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| src/Token.sol                           | ERC20, ERC721                |
| src/NFT.sol                             | ERC721                       |


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

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Attack ideas (where to focus for bugs)
None

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## All trusted roles in the protocol

Operator

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Owner                          | Has superpowers                |
| Administrator                             | Can change fees                       |

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

N/A

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Running tests

git clone https://github.com/Generative-Labs/chakra-settlement-contracts.git
git checkout audit

✅ SCOUTS: Please format the response above 👆 using the template below👇

```bash
git clone https://github.com/code-423n4/2023-08-arbitrum
git submodule update --init --recursive
cd governance
foundryup
make install
make build
make sc-election-test
```
To run code coverage
```bash
make coverage
```
To run gas benchmarks
```bash
make gas
```

✅ SCOUTS: Add a screenshot of your terminal showing the gas report
✅ SCOUTS: Add a screenshot of your terminal showing the test coverage


# Scope

*See [scope.txt](https://github.com/code-423n4/2024-08-chakra/blob/main/scope.txt)*

### Files in scope


| File   | Logic Contracts | Interfaces | nSLOC | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /solidity/handler/contracts/BaseSettlementHandler.sol | 1| **** | 95 | |contracts/interfaces/ISettlement.sol<br>contracts/interfaces/IERC20CodecV1.sol<br>contracts/interfaces/ISettlementSignatureVerifier.sol<br>contracts/libraries/AddressCast.sol<br>contracts/libraries/Message.sol<br>contracts/libraries/MessageV1Codec.sol<br>@openzeppelin/contracts/token/ERC20/IERC20.sol<br>@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>contracts/libraries/ERC20Payload.sol<br>@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol<br>@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol|
| /solidity/handler/contracts/ChakraSettlementHandler.sol | 1| **** | 225 | |hardhat/console.sol<br>contracts/interfaces/ISettlement.sol<br>contracts/interfaces/IERC20CodecV1.sol<br>contracts/interfaces/IERC20Mint.sol<br>contracts/interfaces/IERC20Burn.sol<br>contracts/interfaces/ISettlementHandler.sol<br>contracts/libraries/AddressCast.sol<br>contracts/libraries/Message.sol<br>contracts/libraries/MessageV1Codec.sol<br>@openzeppelin/contracts/token/ERC20/IERC20.sol<br>contracts/BaseSettlementHandler.sol<br>contracts/libraries/ERC20Payload.sol|
| /solidity/handler/contracts/ChakraToken.sol | 1| **** | 32 | |contracts/interfaces/IERC20Mint.sol<br>contracts/interfaces/IERC20Burn.sol<br>@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol<br>contracts/TokenRoles.sol|
| /solidity/handler/contracts/ChakraTokenUpgradeTest.sol | 1| **** | 27 | |@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol<br>contracts/TokenRoles.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol|
| /solidity/handler/contracts/ERC20CodecV1.sol | 1| **** | 33 | |contracts/interfaces/IERC20CodecV1.sol<br>@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>contracts/libraries/ERC20Payload.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol|
| /solidity/handler/contracts/SettlementSignatureVerifier.sol | 1| **** | 96 | |@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>@openzeppelin/contracts/utils/cryptography/ECDSA.sol<br>@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol|
| /solidity/handler/contracts/TokenRoles.sol | 1| **** | 34 | |@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol|
| /solidity/handler/contracts/libraries/AddressCast.sol | 1| **** | 36 | ||
| /solidity/handler/contracts/libraries/ERC20Payload.sol | ****| **** | 17 | ||
| /solidity/handler/contracts/libraries/Message.sol | ****| **** | 21 | ||
| /solidity/handler/contracts/libraries/MessageV1Codec.sol | 1| **** | 45 | |contracts/libraries/Message.sol<br>contracts/libraries/AddressCast.sol|
| /solidity/settlement/contracts/BaseSettlement.sol | 1| **** | 89 | |@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol<br>contracts/interfaces/ISettlementSignatureVerifier.sol|
| /solidity/settlement/contracts/ChakraSettlement.sol | 1| **** | 221 | |contracts/BaseSettlement.sol<br>contracts/interfaces/ISettlementHandler.sol<br>contracts/interfaces/ISettlementSignatureVerifier.sol<br>contracts/libraries/Message.sol|
| /solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol | 1| **** | 226 | |contracts/BaseSettlement.sol<br>contracts/interfaces/ISettlementHandler.sol<br>contracts/interfaces/ISettlementSignatureVerifier.sol<br>contracts/libraries/Message.sol|
| /solidity/settlement/contracts/SettlementSignatureVerifier.sol | 1| **** | 97 | |contracts/interfaces/ISettlementSignatureVerifier.sol<br>@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol<br>@openzeppelin/contracts/utils/cryptography/ECDSA.sol<br>@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol|
| /solidity/settlement/contracts/libraries/AddressCast.sol | 1| **** | 36 | ||
| /solidity/settlement/contracts/libraries/Message.sol | ****| **** | 21 | ||
| /solidity/settlement/contracts/libraries/MessageV1Codec.sol | 1| **** | 42 | |contracts/libraries/Message.sol|
| **Totals** | **15** | **** | **1393** | | |

### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2024-08-chakra/blob/main/out_of_scope.txt)*

| File         |
| ------------ |
| ./cairo/handler/src/tests/test_settlement.cairo |
| ./solidity/handler/contracts/interfaces/IERC20Burn.sol |
| ./solidity/handler/contracts/interfaces/IERC20CodecV1.sol |
| ./solidity/handler/contracts/interfaces/IERC20Mint.sol |
| ./solidity/handler/contracts/interfaces/ISettlement.sol |
| ./solidity/handler/contracts/interfaces/ISettlementHandler.sol |
| ./solidity/handler/contracts/interfaces/ISettlementSignatureVerifier.sol |
| ./solidity/handler/contracts/tests/BaseSettlement.t.sol |
| ./solidity/handler/contracts/tests/MessageLib.t.sol |
| ./solidity/handler/contracts/tests/Settlement.t.sol |
| ./solidity/handler/contracts/tests/SettlementSignatureVerifier.t.sol |
| ./solidity/settlement/contracts/interfaces/IERC20Burn.sol |
| ./solidity/settlement/contracts/interfaces/IERC20Mint.sol |
| ./solidity/settlement/contracts/interfaces/ISettlement.sol |
| ./solidity/settlement/contracts/interfaces/ISettlementHandler.sol |
| ./solidity/settlement/contracts/interfaces/ISettlementSignatureVerifier.sol |
| ./solidity/settlement/contracts/tests/BaseSettlementHandler.t.sol |
| ./solidity/settlement/contracts/tests/ERC20CodecV1.t.sol |
| ./solidity/settlement/contracts/tests/ERC20Payload.t.sol |
| ./solidity/settlement/contracts/tests/ERC20SettlementHandler.t.sol |
| ./solidity/settlement/contracts/tests/IERC20CodecV1.t.sol |
| ./solidity/settlement/contracts/tests/MessageLib.t.sol |
| ./solidity/settlement/contracts/tests/MyToken.t.sol |
| ./solidity/settlement/contracts/tests/MyTokenUpgradeTest.t.sol |
| ./solidity/settlement/contracts/tests/TokenRoles.t.sol |
| Totals: 25 |

## Miscellaneous
Employees of Chakra and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.

