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
- Total Prize Pool: $67500 in USDC
  - HM awards: $49450 in USDC
  - (remove this line if there is no Analysis pool) Analysis awards: XXX XXX USDC (Notion: Analysis pool)
  - QA awards: $2050 in USDC
  - (remove this line if there is no Bot race) Bot Race awards: XXX XXX USDC (Notion: Bot Race pool)
 
  - Judge awards: $5000 in USDC
  - Validator awards: XXX XXX USDC (Notion: Triage fee - final)
  - Scout awards: $500 in USDC
  - (this line can be removed if there is no mitigation) Mitigation Review: XXX XXX USDC (*Opportunity goes to top 3 backstage wardens based on placement in this audit who RSVP.*)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts August 28, 2024 20:00 UTC
- Ends September 11, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-08-chakra/blob/main/4naly3er-report.md).



_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._
## 🐺 C4: Begin Gist paste here (and delete this line)





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

