# Chakra Settlement Handler Template

This project aims to help users quickly build settlement handlers on Chakra 🚀.

## Getting Started
This project depends on [Nodejs](https://nodejs.org/en) and [yarn](https://yarnpkg.com/), so make sure you have them installed in your environment before you start.

1. Install dependencies
    ```shell
    yarn
    ```
2. Build & Test
    ```shell
    npx hardhat build
    npx hardhat test
    ```

## Development

### Token Development

1. If you haven't deployed a token yet, you can refer to [MyToken](contracts/MyToken.sol) to quickly implement a token contract with the following features:
    - Implemented upgradable contract based on OpenZeppelin
    - Implemented [TokenRoles](contracts/TokenRoles.sol) for permission management
    - Implemented [IERC20Mint](contracts/interfaces/IERC20Mint.sol)
    - Implemented [IERC20Burn](contracts/interfaces/IERC20Burn.sol)
2. If your contract is upgradable and allows minting and burning, you can refer to [MyToken](contracts/MyToken.sol) to implement permission management and mint, burn mechanisms.

### Settlement Handler Development

The specific implementation of the settlement handler depends on what the user needs to build. We provide the `ERC20SettlementHandler` implementation for developers to use and refer to. You can also implement the corresponding `SettlementHandler` based on your own requirements. Here are the steps to implement a SettlementHandler:

1. Define the Payload
    
    - [Message](contracts/libraries/Message.sol) defines the message structure for cross-chain settlement, where `bytes payload` allows developers to implement their own codec for encoding and decoding.
    - **Developers** need to define the codec interface and implementation, then initialize the deployed codec contract within the `SettlementHandler` contract.
    - You can refer to [ERC20Payload](contracts/libraries/ERC20Payload.sol) and [IERC20Codec](contracts/interfaces/IERC20CodecV1.sol), [ERC20CodecV1](contracts/ERC20CodecV1.sol) to define the `bytes payload` structure and the corresponding codec implementation for ERC20 cross-chain settlement.

2. Implement `SettlementHandler`
    - [ISettlementHandler](contracts/interfaces/ISettlementHandler.sol) defines the interface required to implement the `SettlementHandler`, and developers can implement a specific `SettlementHandler` based on this interface and refer to [ERC20SettlementHandler](contracts/ERC20SettlementHandler.sol).

## Deployment
In the [hardhat config](hardhat.config.ts), configure the RPC and related parameters for the EVM-compatible chain you want to deploy to. Here's an example:

```
 networks: {
    localhost: {
      url: "http://localhost:8545",
      accounts: ["<Your private key>"],
      gas: "auto",
      gasPrice: "auto"
    }
  }
```

Then, use the [deploy_allinone_template.js](scripts/deploy_allinone_template.js) script to deploy all the contracts required for the `SettlementHandler`. You need to modify the content in this script.

**Deploy cmd**
```bash
npx hardhat run scripts/<YourDeployScriptFile>.js --network <network> --config <hardhat_config_ts_file>
```

### Verify Contract

```bash
npx hardhat verify --network <network_name> <contract_address>
```
