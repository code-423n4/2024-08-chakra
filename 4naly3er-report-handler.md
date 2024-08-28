# Report

- [Report](#report)
  - [Gas Optimizations](#gas-optimizations)
    - [\[GAS-1\] Don't use `_msgSender()` if not supporting EIP-2771](#gas-1-dont-use-_msgsender-if-not-supporting-eip-2771)
    - [\[GAS-2\] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)](#gas-2-a--a--b-is-more-gas-effective-than-a--b-for-state-variables-excluding-arrays-and-mappings)
    - [\[GAS-3\] Comparing to a Boolean constant](#gas-3-comparing-to-a-boolean-constant)
    - [\[GAS-4\] Using bools for storage incurs overhead](#gas-4-using-bools-for-storage-incurs-overhead)
    - [\[GAS-5\] State variables should be cached in stack variables rather than re-reading them from storage](#gas-5-state-variables-should-be-cached-in-stack-variables-rather-than-re-reading-them-from-storage)
    - [\[GAS-6\] Use calldata instead of memory for function arguments that do not get mutated](#gas-6-use-calldata-instead-of-memory-for-function-arguments-that-do-not-get-mutated)
    - [\[GAS-7\] For Operations that will not overflow, you could use unchecked](#gas-7-for-operations-that-will-not-overflow-you-could-use-unchecked)
    - [\[GAS-8\] Use Custom Errors instead of Revert Strings to save Gas](#gas-8-use-custom-errors-instead-of-revert-strings-to-save-gas)
    - [\[GAS-9\] Avoid contract existence checks by using low level calls](#gas-9-avoid-contract-existence-checks-by-using-low-level-calls)
    - [\[GAS-10\] Stack variable used as a cheaper cache for a state variable is only used once](#gas-10-stack-variable-used-as-a-cheaper-cache-for-a-state-variable-is-only-used-once)
    - [\[GAS-11\] Functions guaranteed to revert when called by normal users can be marked `payable`](#gas-11-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)
    - [\[GAS-12\] Using `private` rather than `public` for constants, saves gas](#gas-12-using-private-rather-than-public-for-constants-saves-gas)
    - [\[GAS-13\] Use shift right/left instead of division/multiplication if possible](#gas-13-use-shift-rightleft-instead-of-divisionmultiplication-if-possible)
    - [\[GAS-14\] `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas](#gas-14-uint256-to-bool-mapping-utilizing-bitmaps-to-dramatically-save-on-gas)
    - [\[GAS-15\] Use != 0 instead of \> 0 for unsigned integer comparison](#gas-15-use--0-instead-of--0-for-unsigned-integer-comparison)
    - [\[GAS-16\] `internal` functions not called by the contract should be removed](#gas-16-internal-functions-not-called-by-the-contract-should-be-removed)
  - [Non Critical Issues](#non-critical-issues)
    - [\[NC-1\] Missing checks for `address(0)` when assigning values to address state variables](#nc-1-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[NC-2\] Array indices should be referenced via `enum`s rather than via numeric literals](#nc-2-array-indices-should-be-referenced-via-enums-rather-than-via-numeric-literals)
    - [\[NC-3\] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`](#nc-3-use-stringconcat-or-bytesconcat-instead-of-abiencodepacked)
    - [\[NC-4\] `constant`s should be defined rather than using magic numbers](#nc-4-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-5\] Control structures do not follow the Solidity Style Guide](#nc-5-control-structures-do-not-follow-the-solidity-style-guide)
    - [\[NC-6\] Delete rogue `console.log` imports](#nc-6-delete-rogue-consolelog-imports)
    - [\[NC-7\] Consider disabling `renounceOwnership()`](#nc-7-consider-disabling-renounceownership)
    - [\[NC-8\] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function](#nc-8-duplicated-requirerevert-checks-should-be-refactored-to-a-modifier-or-function)
    - [\[NC-9\] Event is never emitted](#nc-9-event-is-never-emitted)
    - [\[NC-10\] Event missing indexed field](#nc-10-event-missing-indexed-field)
    - [\[NC-11\] Events that mark critical parameter changes should contain both the old and the new value](#nc-11-events-that-mark-critical-parameter-changes-should-contain-both-the-old-and-the-new-value)
    - [\[NC-12\] Function ordering does not follow the Solidity style guide](#nc-12-function-ordering-does-not-follow-the-solidity-style-guide)
    - [\[NC-13\] Functions should not be longer than 50 lines](#nc-13-functions-should-not-be-longer-than-50-lines)
    - [\[NC-14\] Change int to int256](#nc-14-change-int-to-int256)
    - [\[NC-15\] NatSpec is completely non-existent on functions that should have them](#nc-15-natspec-is-completely-non-existent-on-functions-that-should-have-them)
    - [\[NC-16\] Incomplete NatSpec: `@param` is missing on actually documented functions](#nc-16-incomplete-natspec-param-is-missing-on-actually-documented-functions)
    - [\[NC-17\] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor](#nc-17-use-a-modifier-instead-of-a-requireif-statement-for-a-special-msgsender-actor)
    - [\[NC-18\] Consider using named mappings](#nc-18-consider-using-named-mappings)
    - [\[NC-19\] Adding a `return` statement when the function defines a named return variable, is redundant](#nc-19-adding-a-return-statement-when-the-function-defines-a-named-return-variable-is-redundant)
    - [\[NC-20\] Take advantage of Custom Error's return value property](#nc-20-take-advantage-of-custom-errors-return-value-property)
    - [\[NC-21\] Avoid the use of sensitive terms](#nc-21-avoid-the-use-of-sensitive-terms)
    - [\[NC-22\] Contract does not follow the Solidity style guide's suggested layout ordering](#nc-22-contract-does-not-follow-the-solidity-style-guides-suggested-layout-ordering)
    - [\[NC-23\] Internal and private variables and functions names should begin with an underscore](#nc-23-internal-and-private-variables-and-functions-names-should-begin-with-an-underscore)
    - [\[NC-24\] Event is missing `indexed` fields](#nc-24-event-is-missing-indexed-fields)
    - [\[NC-25\] `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings](#nc-25-override-function-arguments-that-are-unused-should-have-the-variable-name-removed-or-commented-out-to-avoid-compiler-warnings)
    - [\[NC-26\] `public` functions not called by the contract should be declared `external` instead](#nc-26-public-functions-not-called-by-the-contract-should-be-declared-external-instead)
    - [\[NC-27\] Variables need not be initialized to zero](#nc-27-variables-need-not-be-initialized-to-zero)
  - [Low Issues](#low-issues)
    - [\[L-1\] Use a 2-step ownership transfer pattern](#l-1-use-a-2-step-ownership-transfer-pattern)
    - [\[L-2\] Some tokens may revert when zero value transfers are made](#l-2-some-tokens-may-revert-when-zero-value-transfers-are-made)
    - [\[L-3\] Missing checks for `address(0)` when assigning values to address state variables](#l-3-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[L-4\] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`](#l-4-abiencodepacked-should-not-be-used-with-dynamic-types-when-passing-the-result-to-a-hash-function-such-as-keccak256)
    - [\[L-5\] Empty Function Body - Consider commenting why](#l-5-empty-function-body---consider-commenting-why)
    - [\[L-6\] Initializers could be front-run](#l-6-initializers-could-be-front-run)
    - [\[L-7\] Prevent accidentally burning tokens](#l-7-prevent-accidentally-burning-tokens)
    - [\[L-8\] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`](#l-8-solidity-version-0820-may-not-work-on-other-chains-due-to-push0)
    - [\[L-9\] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`](#l-9-use-ownable2steptransferownership-instead-of-ownabletransferownership)
    - [\[L-10\] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting](#l-10-consider-using-openzeppelins-safecast-library-to-prevent-unexpected-overflows-when-downcasting)
    - [\[L-11\] Unsafe ERC20 operation(s)](#l-11-unsafe-erc20-operations)
    - [\[L-12\] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions](#l-12-upgradeable-contract-is-missing-a-__gap50-storage-variable-to-allow-for-new-storage-variables-in-later-versions)
    - [\[L-13\] Upgradeable contract not initialized](#l-13-upgradeable-contract-not-initialized)
  - [Medium Issues](#medium-issues)
    - [\[M-1\] Centralization Risk for trusted owners](#m-1-centralization-risk-for-trusted-owners)
      - [Impact](#impact)
    - [\[M-2\] Return values of `transfer()`/`transferFrom()` not checked](#m-2-return-values-of-transfertransferfrom-not-checked)
    - [\[M-3\] Unsafe use of `transfer()`/`transferFrom()`/`approve()`/ with `IERC20`](#m-3-unsafe-use-of-transfertransferfromapprove-with-ierc20)

## Gas Optimizations

| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Don't use `_msgSender()` if not supporting EIP-2771 | 2 |
| [GAS-2](#GAS-2) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 4 |
| [GAS-3](#GAS-3) | Comparing to a Boolean constant | 5 |
| [GAS-4](#GAS-4) | Using bools for storage incurs overhead | 2 |
| [GAS-5](#GAS-5) | State variables should be cached in stack variables rather than re-reading them from storage | 1 |
| [GAS-6](#GAS-6) | Use calldata instead of memory for function arguments that do not get mutated | 21 |
| [GAS-7](#GAS-7) | For Operations that will not overflow, you could use unchecked | 84 |
| [GAS-8](#GAS-8) | Use Custom Errors instead of Revert Strings to save Gas | 9 |
| [GAS-9](#GAS-9) | Avoid contract existence checks by using low level calls | 4 |
| [GAS-10](#GAS-10) | Stack variable used as a cheaper cache for a state variable is only used once | 1 |
| [GAS-11](#GAS-11) | Functions guaranteed to revert when called by normal users can be marked `payable` | 8 |
| [GAS-12](#GAS-12) | Using `private` rather than `public` for constants, saves gas | 2 |
| [GAS-13](#GAS-13) | Use shift right/left instead of division/multiplication if possible | 2 |
| [GAS-14](#GAS-14) | `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas | 1 |
| [GAS-15](#GAS-15) | Use != 0 instead of > 0 for unsigned integer comparison | 1 |
| [GAS-16](#GAS-16) | `internal` functions not called by the contract should be removed | 14 |

### <a name="GAS-1"></a>[GAS-1] Don't use `_msgSender()` if not supporting EIP-2771

Use `msg.sender` if the code does not implement [EIP-2771 trusted forwarder](https://eips.ethereum.org/EIPS/eip-2771) support

*Instances (2)*:

```solidity
File: contracts/ChakraToken.sol

51:         _mint(_msgSender(), value);

71:         _burn(_msgSender(), value);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

### <a name="GAS-2"></a>[GAS-2] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)

This saves **16 gas per instance.**

*Instances (4)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

135:             nonce_manager[msg.sender] += 1;

169:             cross_chain_msg_id_counter += 1;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

79:         validator_count += 1;

131:         for (uint256 i = 0; i < len; i += 65) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-3"></a>[GAS-3] Comparing to a Boolean constant

Comparing to a constant (`true` or `false`) is a bit more expensive than directly checking the returned boolean value.

Consider using `if(directValue)` instead of `if(directValue == true)` and `if(!directValue)` instead of `if(directValue == false)`

*Instances (5)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

311:         if (is_valid_handler(from_chain, from_handler) == false) {

374:         if (is_valid_handler(from_chain, from_handler) == false) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

43:         require(validators[msg.sender] == true, "Not validator");

77:         require(validators[validator] == false, "Validator already exists");

86:         require(validators[validator] == true, "Validator does not exists");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-4"></a>[GAS-4] Using bools for storage incurs overhead

Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (2)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

19:     mapping(string => mapping(uint256 => bool)) public handler_whitelist;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

39:     mapping(address => bool) public validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-5"></a>[GAS-5] State variables should be cached in stack variables rather than re-reading them from storage

The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (1)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

97:         emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-6"></a>[GAS-6] Use calldata instead of memory for function arguments that do not get mutated

When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop.

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one.

 *Saves 60 gas per instance*

*Instances (21)*:

```solidity
File: contracts/BaseSettlementHandler.sol

118:         string memory _chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

42:         string memory chain_name,

54:         string memory chain_name,

66:         string memory chain_name,

85:         string memory _chain,

112:         string memory to_chain,

302:         string memory from_chain,

367:         string memory from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

29:         string memory _name,

30:         string memory _symbol,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

16:         string memory _name,

17:         string memory _symbol,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

37:         ERC20TransferPayload memory _payload

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/interfaces/IERC20CodecV1.sol

17:         ERC20TransferPayload memory payload

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/IERC20CodecV1.sol)

```solidity
File: contracts/interfaces/ISettlement.sol

9:         string memory to_chain,

18:         string memory from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/ISettlement.sol)

```solidity
File: contracts/interfaces/ISettlementHandler.sol

9:         string memory from_chain,

18:         string memory from_chain,

29:         string memory chain_name,

33:     function add_handler(string memory chain_name, uint256 handler) external;

35:     function remove_handler(string memory chain_name, uint256 handler) external;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/ISettlementHandler.sol)

### <a name="GAS-7"></a>[GAS-7] For Operations that will not overflow, you could use unchecked

*Instances (84)*:

```solidity
File: contracts/BaseSettlementHandler.sol

4: import {ISettlement} from "contracts/interfaces/ISettlement.sol";

5: import {IERC20CodecV1} from "contracts/interfaces/IERC20CodecV1.sol";

6: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

7: import {AddressCast} from "contracts/libraries/AddressCast.sol";

8: import {Message, PayloadType} from "contracts/libraries/Message.sol";

9: import {MessageV1Codec} from "contracts/libraries/MessageV1Codec.sol";

10: import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

11: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

12: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

13: import "contracts/libraries/ERC20Payload.sol";

14: import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

15: import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

16: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

4: import "hardhat/console.sol";

6: import {ISettlement} from "contracts/interfaces/ISettlement.sol";

7: import {IERC20CodecV1} from "contracts/interfaces/IERC20CodecV1.sol";

8: import {IERC20Mint} from "contracts/interfaces/IERC20Mint.sol";

9: import {IERC20Burn} from "contracts/interfaces/IERC20Burn.sol";

10: import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";

11: import {AddressCast} from "contracts/libraries/AddressCast.sol";

12: import {Message, PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";

13: import {MessageV1Codec} from "contracts/libraries/MessageV1Codec.sol";

14: import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

15: import {BaseSettlementHandler} from "contracts/BaseSettlementHandler.sol";

16: import "contracts/libraries/ERC20Payload.sol";

135:             nonce_manager[msg.sender] += 1;

144:                     msg.sender, // from address for settlement to calculate txid

145:                     address(this), //  from handler for settlement to calculate txid

169:             cross_chain_msg_id_counter += 1;

301:         uint256 /**txid */,

303:         uint256 /**from_address */,

307:         uint8 /**sign type */,

308:         bytes calldata /**signaturs */

370:         uint8 /* sign_type */, // validators signature type /  multisig or bls sr25519

371:         bytes calldata /* signatures */

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

5: import {IERC20Mint} from "contracts/interfaces/IERC20Mint.sol";

6: import {IERC20Burn} from "contracts/interfaces/IERC20Burn.sol";

7: import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

8: import {TokenRoles} from "contracts/TokenRoles.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

4: import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

7: import {TokenRoles} from "contracts/TokenRoles.sol";

8: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

4: import {IERC20CodecV1} from "contracts/interfaces/IERC20CodecV1.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import "contracts/libraries/ERC20Payload.sol";

7: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

4: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

7: import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

8: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

79:         validator_count += 1;

88:         validator_count -= 1;

131:         for (uint256 i = 0; i < len; i += 65) {

132:             bytes memory sig = signatures[i:i + 65];

134:                 validators[msgHash.recover(sig)] && ++m >= required_validators

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

4: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

5: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

6: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

```solidity
File: contracts/interfaces/IERC20CodecV1.sol

4: import "contracts/libraries/ERC20Payload.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/IERC20CodecV1.sol)

```solidity
File: contracts/interfaces/ISettlement.sol

4: import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";

5: import {PayloadType} from "contracts/libraries/Message.sol";

24:         uint8 sign_type, // validators signature type /  multisig or bls sr25519

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/ISettlement.sol)

```solidity
File: contracts/interfaces/ISettlementHandler.sol

4: import {CrossChainMsgStatus, PayloadType} from "contracts/libraries/Message.sol";

12:         uint8 sign_type, // validators signature type /  multisig or bls sr25519

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/ISettlementHandler.sol)

```solidity
File: contracts/libraries/AddressCast.sol

40:             uint256 offset = 256 - _size * 8;

53:             uint256 offset = 32 - _addressBytes.length;

54:             result = result >> (offset * 8);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/ERC20Payload.sol

9:     Unkown, // 0: Unknown method (also serves as default)

10:     Transfer, // 1: Transfer tokens from one address to another

11:     Arppvoe, // 2: Approve spending of tokens (Note: there's a typo, should be "Approve")

12:     TransferFrom, // 3: Transfer tokens on behalf of another address

13:     Mint, // 4: Create new tokens

14:     Burn // 5: Destroy existing tokens

22:     ERC20Method method_id; // The method identifier (should be Transfer for this struct)

23:     uint256 from; // The address sending the tokens (as a uint256)

24:     uint256 to; // The address receiving the tokens (as a uint256)

25:     uint256 from_token; // The token address on the source chain (as a uint256)

26:     uint256 to_token; // The token address on the destination chain (as a uint256)

27:     uint256 amount; // The amount of tokens to transfer

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/ERC20Payload.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

4: import {Message, PayloadType} from "contracts/libraries/Message.sol";

5: import {AddressCast} from "contracts/libraries/AddressCast.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

### <a name="GAS-8"></a>[GAS-8] Use Custom Errors instead of Revert Strings to save Gas

Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (9)*:

```solidity
File: contracts/BaseSettlementHandler.sol

131:         require(msg.sender == address(settlement), "Not chakra settlement");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

118:         require(amount > 0, "Amount must be greater than 0");

119:         require(to != 0, "Invalid to address");

120:         require(to_handler != 0, "Invalid to handler address");

121:         require(to_token != 0, "Invalid to token address");

316:         require(isValidPayloadType(payload_type), "Invalid payload type");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

43:         require(validators[msg.sender] == true, "Not validator");

77:         require(validators[validator] == false, "Validator already exists");

86:         require(validators[validator] == true, "Validator does not exists");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-9"></a>[GAS-9] Avoid contract existence checks by using low level calls

Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (4)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

231:             IERC20(token).balanceOf(account) >= amount,

263:             IERC20(token).balanceOf(from) >= amount,

273:             IERC20(token).balanceOf(address(this)) >= amount,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

134:                 validators[msgHash.recover(sig)] && ++m >= required_validators

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-10"></a>[GAS-10] Stack variable used as a cheaper cache for a state variable is only used once

If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (1)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

95:         uint256 old = required_validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-11"></a>[GAS-11] Functions guaranteed to revert when called by normal users can be marked `payable`

If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (8)*:

```solidity
File: contracts/ChakraToken.sol

50:     function mint(uint256 value) external onlyRole(OPERATOR_ROLE) {

70:     function burn(uint256 value) external onlyRole(OPERATOR_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

62:     function add_manager(address _manager) external onlyOwner {

67:     function remove_manager(address _manager) external onlyOwner {

76:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

25:     function transferOwnership(address newOwner) public override onlyOwner {

31:     function add_operator(address newOperator) external onlyOwner {

36:     function remove_operator(address operator) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="GAS-12"></a>[GAS-12] Using `private` rather than `public` for constants, saves gas

If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (2)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

35:     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

17:     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="GAS-13"></a>[GAS-13] Use shift right/left instead of division/multiplication if possible

While the `DIV` / `MUL` opcode uses 5 gas, the `SHR` / `SHL` opcode only uses 3 gas. Furthermore, beware that Solidity's division operation also includes a division-by-0 prevention which is bypassed using shifting. Eventually, overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated, so the calculation can be unchecked in Solidity version `0.8+`

- Use `>> 1` instead of `/ 2`
- Use `>> 2` instead of `/ 4`
- Use `<< 3` instead of `* 8`
- ...
- Use `>> 5` instead of `/ 2^5 == / 32`
- Use `<< 6` instead of `* 2^6 == * 64`

TL;DR:

- Shifting left by N is like multiplying by 2^N (Each bits to the left is an increased power of 2)
- Shifting right by N is like dividing by 2^N (Each bits to the right is a decreased power of 2)

*Saves around 2 gas + 20 for unchecked per instance*

*Instances (2)*:

```solidity
File: contracts/libraries/AddressCast.sol

40:             uint256 offset = 256 - _size * 8;

54:             result = result >> (offset * 8);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

### <a name="GAS-14"></a>[GAS-14] `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas

<https://soliditydeveloper.com/bitmaps>

<https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol>

- [BitMaps.sol#L5-L16](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol#L5-L16):

```solidity
/**
 * @dev Library for managing uint256 to bool mapping in a compact and efficient way, provided the keys are sequential.
 * Largely inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
 *
 * BitMaps pack 256 booleans across each bit of a single 256-bit slot of `uint256` type.
 * Hence booleans corresponding to 256 _sequential_ indices would only consume a single slot,
 * unlike the regular `bool` which would consume an entire slot for a single value.
 *
 * This results in gas savings in two ways:
 *
 * - Setting a zero value to non-zero only once every 256 times
 * - Accessing the same warm slot for every 256 _sequential_ indices
 */
```

*Instances (1)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

19:     mapping(string => mapping(uint256 => bool)) public handler_whitelist;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="GAS-15"></a>[GAS-15] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (1)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

118:         require(amount > 0, "Amount must be greater than 0");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="GAS-16"></a>[GAS-16] `internal` functions not called by the contract should be removed

If the functions are required by an interface, the contract should inherit from that interface and use the `override` keyword

*Instances (14)*:

```solidity
File: contracts/libraries/AddressCast.sol

8:     function to_uint256(

14:     function to_address(

20:     function to_address(

26:     function to_bytes32(

32:     function to_bytes(

47:     function to_bytes32(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

23:     function encode(

34:     function encode_message_header(

40:     function encode_payload(

46:     function header(

52:     function version(bytes calldata _msg) internal pure returns (uint8) {

56:     function id(bytes calldata _msg) internal pure returns (uint64) {

60:     function payload_type(

73:     function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

## Non Critical Issues

| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 2 |
| [NC-3](#NC-3) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 6 |
| [NC-4](#NC-4) | `constant`s should be defined rather than using magic numbers | 10 |
| [NC-5](#NC-5) | Control structures do not follow the Solidity Style Guide | 15 |
| [NC-6](#NC-6) | Delete rogue `console.log` imports | 1 |
| [NC-7](#NC-7) | Consider disabling `renounceOwnership()` | 1 |
| [NC-8](#NC-8) | Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function | 3 |
| [NC-9](#NC-9) | Event is never emitted | 1 |
| [NC-10](#NC-10) | Event missing indexed field | 2 |
| [NC-11](#NC-11) | Events that mark critical parameter changes should contain both the old and the new value | 1 |
| [NC-12](#NC-12) | Function ordering does not follow the Solidity style guide | 6 |
| [NC-13](#NC-13) | Functions should not be longer than 50 lines | 30 |
| [NC-14](#NC-14) | Change int to int256 | 1 |
| [NC-15](#NC-15) | NatSpec is completely non-existent on functions that should have them | 13 |
| [NC-16](#NC-16) | Incomplete NatSpec: `@param` is missing on actually documented functions | 2 |
| [NC-17](#NC-17) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 3 |
| [NC-18](#NC-18) | Consider using named mappings | 5 |
| [NC-19](#NC-19) | Adding a `return` statement when the function defines a named return variable, is redundant | 1 |
| [NC-20](#NC-20) | Take advantage of Custom Error's return value property | 2 |
| [NC-21](#NC-21) | Avoid the use of sensitive terms | 4 |
| [NC-22](#NC-22) | Contract does not follow the Solidity style guide's suggested layout ordering | 3 |
| [NC-23](#NC-23) | Internal and private variables and functions names should begin with an underscore | 19 |
| [NC-24](#NC-24) | Event is missing `indexed` fields | 2 |
| [NC-25](#NC-25) | `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings | 4 |
| [NC-26](#NC-26) | `public` functions not called by the contract should be declared `external` instead | 10 |
| [NC-27](#NC-27) | Variables need not be initialized to zero | 2 |

### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:

```solidity
File: contracts/BaseSettlementHandler.sol

126:         token = _token;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (2)*:

```solidity
File: contracts/ERC20CodecV1.sol

57:         return ERC20Method(uint8(_payload[0]));

68:         transferPayload.method_id = ERC20Method(uint8(_payload[0]));

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

### <a name="NC-3"></a>[NC-3] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`

Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a`bytes`data mixed in the concatenation)`)

*Instances (6)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

141:                 abi.encodePacked(

172:                     abi.encodePacked(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ERC20CodecV1.sol

39:         encodedPaylaod = abi.encodePacked(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

26:         encodedMessage = abi.encodePacked(

37:         return abi.encodePacked(MESSAGE_VERSION, _msg.id, _msg.payload_type);

43:         return abi.encodePacked(_msg.payload);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

### <a name="NC-4"></a>[NC-4] `constant`s should be defined rather than using magic numbers

Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (10)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

125:             signatures.length % 65 == 0,

126:             "Signature length must be a multiple of 65"

131:         for (uint256 i = 0; i < len; i += 65) {

132:             bytes memory sig = signatures[i:i + 65];

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

36:         if (_size == 0 || _size > 32)

40:             uint256 offset = 256 - _size * 8;

42:                 mstore(add(result, 32), shl(offset, _addressBytes32))

50:         if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

53:             uint256 offset = 32 - _addressBytes.length;

54:             result = result >> (offset * 8);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

### <a name="NC-5"></a>[NC-5] Control structures do not follow the Solidity Style Guide

See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (15)*:

```solidity
File: contracts/BaseSettlementHandler.sol

6: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

75:     ISettlementSignatureVerifier public verifier;

117:         address _verifier,

124:         verifier = ISettlementSignatureVerifier(_verifier);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

88:         address _verifier,

96:             _verifier,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

10: contract SettlementSignatureVerifier is

108:     function verify(

114:             return verifyECDSA(msgHash, signatures);

120:     function verifyECDSA(

133:             if (

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/interfaces/ISettlementSignatureVerifier.sol

12:     function verify(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/ISettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

36:         if (_size == 0 || _size > 32)

50:         if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/ERC20Payload.sol

22:     ERC20Method method_id; // The method identifier (should be Transfer for this struct)

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/ERC20Payload.sol)

### <a name="NC-6"></a>[NC-6] Delete rogue `console.log` imports

These shouldn't be deployed in production

*Instances (1)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

4: import "hardhat/console.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="NC-7"></a>[NC-7] Consider disabling `renounceOwnership()`

If the plan for your project does not include eventually giving up all ownership control, consider overwriting OpenZeppelin's `Ownable`'s `renounceOwnership()` function in order to disable it.

*Instances (1)*:

```solidity
File: contracts/ERC20CodecV1.sol

13: contract ERC20CodecV1 is IERC20CodecV1, OwnableUpgradeable, UUPSUpgradeable {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

### <a name="NC-8"></a>[NC-8] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function

*Instances (3)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

230:         require(

262:         require(

272:         require(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="NC-9"></a>[NC-9] Event is never emitted

The following are defined but never emitted. They can be removed to make the code cleaner.

*Instances (1)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

31:     event Test(address validator);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-10"></a>[NC-10] Event missing indexed field

Index event fields make the field more quickly accessible [to off-chain tools](https://ethereum.stackexchange.com/questions/40396/can-somebody-please-explain-the-concept-of-event-indexing) that parse events. This is especially useful when it comes to filtering based on an address. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Where applicable, each `event` should use three `indexed` fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three applicable fields, all of the applicable fields should be indexed.

*Instances (2)*:

```solidity
File: contracts/BaseSettlementHandler.sol

91:     event SentCrossSettlementMsg(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

31:     event Test(address validator);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-11"></a>[NC-11] Events that mark critical parameter changes should contain both the old and the new value

This should especially be done if the new value is not required to be different from the old value

*Instances (1)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

92:     function set_required_validators_num(
            uint256 _required_validators
        ) external virtual onlyRole(MANAGER_ROLE) {
            uint256 old = required_validators;
            required_validators = _required_validators;
            emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-12"></a>[NC-12] Function ordering does not follow the Solidity style guide

According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (6)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

1: 
   Current order:
   public is_valid_handler
   external add_handler
   external remove_handler
   public initialize
   external cross_chain_erc20_settlement
   internal _erc20_mint
   internal _erc20_burn
   internal _erc20_lock
   internal _erc20_unlock
   internal _safe_transfer_from
   internal _safe_transfer
   internal isValidPayloadType
   external receive_cross_chain_msg
   external receive_cross_chain_callback
   
   Suggested order:
   external add_handler
   external remove_handler
   external cross_chain_erc20_settlement
   external receive_cross_chain_msg
   external receive_cross_chain_callback
   public is_valid_handler
   public initialize
   internal _erc20_mint
   internal _erc20_burn
   internal _erc20_lock
   internal _erc20_unlock
   internal _safe_transfer_from
   internal _safe_transfer
   internal isValidPayloadType

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

1: 
   Current order:
   public initialize
   internal _authorizeUpgrade
   external mint
   external mint_to
   external burn
   external burn_from
   public decimals
   public version
   
   Suggested order:
   external mint
   external mint_to
   external burn
   external burn_from
   public initialize
   public decimals
   public version
   internal _authorizeUpgrade

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

1: 
   Current order:
   public initialize
   internal _authorizeUpgrade
   external mint
   external burn
   public decimals
   public version
   
   Suggested order:
   external mint
   external burn
   public initialize
   public decimals
   public version
   internal _authorizeUpgrade

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

1: 
   Current order:
   public initialize
   internal _authorizeUpgrade
   external encode_transfer
   external decode_method
   external deocde_transfer
   
   Suggested order:
   external encode_transfer
   external decode_method
   external deocde_transfer
   public initialize
   internal _authorizeUpgrade

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

1: 
   Current order:
   public initialize
   internal _authorizeUpgrade
   external add_manager
   external remove_manager
   external is_manager
   external add_validator
   external remove_validator
   external set_required_validators_num
   external is_validator
   external view_required_validators_num
   external verify
   internal verifyECDSA
   
   Suggested order:
   external add_manager
   external remove_manager
   external is_manager
   external add_validator
   external remove_validator
   external set_required_validators_num
   external is_validator
   external view_required_validators_num
   external verify
   public initialize
   internal _authorizeUpgrade
   internal verifyECDSA

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

1: 
   Current order:
   public __TokenRoles_init
   public transferOwnership
   external add_operator
   external remove_operator
   public is_operator
   
   Suggested order:
   external add_operator
   external remove_operator
   public __TokenRoles_init
   public transferOwnership
   public is_operator

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="NC-13"></a>[NC-13] Functions should not be longer than 50 lines

Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability

*Instances (30)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

225:     function _erc20_mint(address account, uint256 amount) internal {

229:     function _erc20_burn(address account, uint256 amount) internal {

244:     function _erc20_lock(address from, address to, uint256 amount) internal {

253:     function _erc20_unlock(address to, uint256 amount) internal {

271:     function _safe_transfer(address to, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

50:     function mint(uint256 value) external onlyRole(OPERATOR_ROLE) {

70:     function burn(uint256 value) external onlyRole(OPERATOR_ROLE) {

90:     function decimals() public view override returns (uint8) {

98:     function version() public pure returns (string memory) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

43:     function decimals() public view override returns (uint8) {

47:     function version() public pure returns (string memory) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

18:     function initialize(address _owner) public initializer {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

62:     function add_manager(address _manager) external onlyOwner {

67:     function remove_manager(address _manager) external onlyOwner {

72:     function is_manager(address _manager) external view returns (bool) {

76:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

100:     function is_validator(address _validator) external view returns (bool) {

104:     function view_required_validators_num() external view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

19:     function __TokenRoles_init(address _owner, address _operator) public {

25:     function transferOwnership(address newOwner) public override onlyOwner {

31:     function add_operator(address newOperator) external onlyOwner {

36:     function remove_operator(address operator) external onlyOwner {

41:     function is_operator(address account) public view returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

```solidity
File: contracts/interfaces/IERC20Burn.sol

28:     function burn_from(address account, uint256 value) external;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/IERC20Burn.sol)

```solidity
File: contracts/interfaces/IERC20Mint.sol

28:     function mint_to(address account, uint256 value) external;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/IERC20Mint.sol)

```solidity
File: contracts/interfaces/ISettlementHandler.sol

33:     function add_handler(string memory chain_name, uint256 handler) external;

35:     function remove_handler(string memory chain_name, uint256 handler) external;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/ISettlementHandler.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

52:     function version(bytes calldata _msg) internal pure returns (uint8) {

56:     function id(bytes calldata _msg) internal pure returns (uint64) {

73:     function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

### <a name="NC-14"></a>[NC-14] Change int to int256

Throughout the code base, some variables are declared as `int`. To favor explicitness, consider changing all instances of `int` to `int256`

*Instances (1)*:

```solidity
File: contracts/interfaces/IERC20Mint.sol

9: interface IERC20Mint {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/interfaces/IERC20Mint.sol)

### <a name="NC-15"></a>[NC-15] NatSpec is completely non-existent on functions that should have them

Public and external functions that aren't view or pure should have NatSpec comments

*Instances (13)*:

```solidity
File: contracts/BaseSettlementHandler.sol

113:     function _Settlement_handler_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

13:     function initialize(

29:     function mint(

36:     function burn(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

47:     function initialize(

62:     function add_manager(address _manager) external onlyOwner {

67:     function remove_manager(address _manager) external onlyOwner {

76:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

83:     function remove_validator(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

19:     function __TokenRoles_init(address _owner, address _operator) public {

25:     function transferOwnership(address newOwner) public override onlyOwner {

31:     function add_operator(address newOperator) external onlyOwner {

36:     function remove_operator(address operator) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="NC-16"></a>[NC-16] Incomplete NatSpec: `@param` is missing on actually documented functions

The following functions are missing `@param` NatSpec comments.

*Instances (2)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

292:     /**
          * @dev Receives a cross-chain message
          * @param from_chain The source chain
          * @param from_handler The source handler
          * @param payload_type The type of payload
          * @param payload The payload data
          * @return bool True if successful, false otherwise
          */
         function receive_cross_chain_msg(
             uint256 /**txid */,
             string memory from_chain,
             uint256 /**from_address */,
             uint256 from_handler,
             PayloadType payload_type,
             bytes calldata payload,
             uint8 /**sign type */,
             bytes calldata /**signaturs */

357:     /**
          * @dev Receives a cross-chain callback
          * @param txid The transaction ID
          * @param from_chain The source chain
          * @param from_handler The source handler
          * @param status The status of the cross-chain message
          * @return bool True if successful, false otherwise
          */
         function receive_cross_chain_callback(
             uint256 txid,
             string memory from_chain,
             uint256 from_handler,
             CrossChainMsgStatus status,
             uint8 /* sign_type */, // validators signature type /  multisig or bls sr25519
             bytes calldata /* signatures */

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="NC-17"></a>[NC-17] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor

If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (3)*:

```solidity
File: contracts/BaseSettlementHandler.sol

131:         require(msg.sender == address(settlement), "Not chakra settlement");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

43:         require(validators[msg.sender] == true, "Not validator");

97:         emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-18"></a>[NC-18] Consider using named mappings

Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (5)*:

```solidity
File: contracts/BaseSettlementHandler.sol

83:     mapping(address => uint256) public nonce_manager;

84:     mapping(uint256 => CreatedCrossChainTx) public create_cross_txs;

111:     mapping(uint256 => HandlerTransaction) public handler_transactions;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

19:     mapping(string => mapping(uint256 => bool)) public handler_whitelist;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

39:     mapping(address => bool) public validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-19"></a>[NC-19] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (1)*:

```solidity
File: contracts/ERC20CodecV1.sol

49:     /**
         * @dev Decodes the method from a payload
         * @param _payload Encoded payload
         * @return method The decoded ERC20Method
         */
        function decode_method(
            bytes calldata _payload
        ) external pure returns (ERC20Method method) {
            return ERC20Method(uint8(_payload[0]));

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

### <a name="NC-20"></a>[NC-20] Take advantage of Custom Error's return value property

An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (2)*:

```solidity
File: contracts/libraries/AddressCast.sol

37:             revert AddressCast_InvalidSizeForAddress();

50:         if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

### <a name="NC-21"></a>[NC-21] Avoid the use of sensitive terms

Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (4)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

19:     mapping(string => mapping(uint256 => bool)) public handler_whitelist;

45:         return handler_whitelist[chain_name][handler];

57:         handler_whitelist[chain_name][handler] = true;

69:         handler_whitelist[chain_name][handler] = false;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="NC-22"></a>[NC-22] Contract does not follow the Solidity style guide's suggested layout ordering

The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (3)*:

```solidity
File: contracts/BaseSettlementHandler.sol

1: 
   Current order:
   EnumDefinition.CrossChainTxStatus
   EnumDefinition.SettlementMode
   EventDefinition.CrossChainLocked
   StructDefinition.CreatedCrossChainTx
   VariableDeclaration.mode
   VariableDeclaration.token
   VariableDeclaration.verifier
   VariableDeclaration.settlement
   VariableDeclaration.nonce_manager
   VariableDeclaration.create_cross_txs
   VariableDeclaration.cross_chain_msg_id_counter
   VariableDeclaration.chain
   EventDefinition.SentCrossSettlementMsg
   EnumDefinition.HandlerStatus
   StructDefinition.HandlerTransaction
   VariableDeclaration.handler_transactions
   FunctionDefinition._Settlement_handler_init
   ModifierDefinition.onlySettlement
   FunctionDefinition._authorizeUpgrade
   
   Suggested order:
   VariableDeclaration.mode
   VariableDeclaration.token
   VariableDeclaration.verifier
   VariableDeclaration.settlement
   VariableDeclaration.nonce_manager
   VariableDeclaration.create_cross_txs
   VariableDeclaration.cross_chain_msg_id_counter
   VariableDeclaration.chain
   VariableDeclaration.handler_transactions
   EnumDefinition.CrossChainTxStatus
   EnumDefinition.SettlementMode
   EnumDefinition.HandlerStatus
   StructDefinition.CreatedCrossChainTx
   StructDefinition.HandlerTransaction
   EventDefinition.CrossChainLocked
   EventDefinition.SentCrossSettlementMsg
   ModifierDefinition.onlySettlement
   FunctionDefinition._Settlement_handler_init
   FunctionDefinition._authorizeUpgrade

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

1: 
   Current order:
   UsingForDirective.ECDSA
   EventDefinition.ValidatorAdded
   EventDefinition.ValidatorRemoved
   EventDefinition.ManagerAdded
   EventDefinition.ManagerRemoved
   EventDefinition.RequiredValidatorsChanged
   EventDefinition.Test
   VariableDeclaration.MANAGER_ROLE
   VariableDeclaration.required_validators
   VariableDeclaration.validators
   VariableDeclaration.validator_count
   ModifierDefinition.onlyValidator
   FunctionDefinition.initialize
   FunctionDefinition._authorizeUpgrade
   FunctionDefinition.add_manager
   FunctionDefinition.remove_manager
   FunctionDefinition.is_manager
   FunctionDefinition.add_validator
   FunctionDefinition.remove_validator
   FunctionDefinition.set_required_validators_num
   FunctionDefinition.is_validator
   FunctionDefinition.view_required_validators_num
   FunctionDefinition.verify
   FunctionDefinition.verifyECDSA
   
   Suggested order:
   UsingForDirective.ECDSA
   VariableDeclaration.MANAGER_ROLE
   VariableDeclaration.required_validators
   VariableDeclaration.validators
   VariableDeclaration.validator_count
   EventDefinition.ValidatorAdded
   EventDefinition.ValidatorRemoved
   EventDefinition.ManagerAdded
   EventDefinition.ManagerRemoved
   EventDefinition.RequiredValidatorsChanged
   EventDefinition.Test
   ModifierDefinition.onlyValidator
   FunctionDefinition.initialize
   FunctionDefinition._authorizeUpgrade
   FunctionDefinition.add_manager
   FunctionDefinition.remove_manager
   FunctionDefinition.is_manager
   FunctionDefinition.add_validator
   FunctionDefinition.remove_validator
   FunctionDefinition.set_required_validators_num
   FunctionDefinition.is_validator
   FunctionDefinition.view_required_validators_num
   FunctionDefinition.verify
   FunctionDefinition.verifyECDSA

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

1: 
   Current order:
   EventDefinition.OperatorAdded
   EventDefinition.OperatorRemoved
   VariableDeclaration.OPERATOR_ROLE
   FunctionDefinition.__TokenRoles_init
   FunctionDefinition.transferOwnership
   FunctionDefinition.add_operator
   FunctionDefinition.remove_operator
   FunctionDefinition.is_operator
   
   Suggested order:
   VariableDeclaration.OPERATOR_ROLE
   EventDefinition.OperatorAdded
   EventDefinition.OperatorRemoved
   FunctionDefinition.__TokenRoles_init
   FunctionDefinition.transferOwnership
   FunctionDefinition.add_operator
   FunctionDefinition.remove_operator
   FunctionDefinition.is_operator

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="NC-23"></a>[NC-23] Internal and private variables and functions names should begin with an underscore

According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (19)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

286:     function isValidPayloadType(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

16:     uint8 set_decimals;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

11:     uint8 set_decimals;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

120:     function verifyECDSA(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

8:     function to_uint256(

14:     function to_address(

20:     function to_address(

26:     function to_bytes32(

32:     function to_bytes(

47:     function to_bytes32(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

23:     function encode(

34:     function encode_message_header(

40:     function encode_payload(

46:     function header(

52:     function version(bytes calldata _msg) internal pure returns (uint8) {

56:     function id(bytes calldata _msg) internal pure returns (uint64) {

60:     function payload_type(

67:     function payload(

73:     function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

### <a name="NC-24"></a>[NC-24] Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (2)*:

```solidity
File: contracts/BaseSettlementHandler.sol

91:     event SentCrossSettlementMsg(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

31:     event Test(address validator);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-25"></a>[NC-25] `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings

*Instances (4)*:

```solidity
File: contracts/ChakraToken.sol

43:         address newImplementation

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

26:         address newImplementation

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

28:         address newImplementation

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

59:         address newImplementation

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-26"></a>[NC-26] `public` functions not called by the contract should be declared `external` instead

*Instances (10)*:

```solidity
File: contracts/BaseSettlementHandler.sol

113:     function _Settlement_handler_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

82:     function initialize(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

26:     function initialize(

98:     function version() public pure returns (string memory) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

13:     function initialize(

47:     function version() public pure returns (string memory) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

18:     function initialize(address _owner) public initializer {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

47:     function initialize(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

19:     function __TokenRoles_init(address _owner, address _operator) public {

41:     function is_operator(address account) public view returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="NC-27"></a>[NC-27] Variables need not be initialized to zero

The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (2)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

130:         uint256 m = 0;

131:         for (uint256 i = 0; i < len; i += 65) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

## Low Issues

| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Use a 2-step ownership transfer pattern | 1 |
| [L-2](#L-2) | Some tokens may revert when zero value transfers are made | 2 |
| [L-3](#L-3) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [L-4](#L-4) | `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 4 |
| [L-5](#L-5) | Empty Function Body - Consider commenting why | 3 |
| [L-6](#L-6) | Initializers could be front-run | 23 |
| [L-7](#L-7) | Prevent accidentally burning tokens | 10 |
| [L-8](#L-8) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 9 |
| [L-9](#L-9) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 7 |
| [L-10](#L-10) | Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting | 3 |
| [L-11](#L-11) | Unsafe ERC20 operation(s) | 2 |
| [L-12](#L-12) | Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions | 31 |
| [L-13](#L-13) | Upgradeable contract not initialized | 51 |

### <a name="L-1"></a>[L-1] Use a 2-step ownership transfer pattern

Recommend considering implementing a two step process where the owner or admin nominates an account and the nominated account needs to call an `acceptOwnership()` function for the transfer of ownership to fully succeed. This ensures the nominated EOA account is a valid and active account. Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (1)*:

```solidity
File: contracts/ERC20CodecV1.sol

13: contract ERC20CodecV1 is IERC20CodecV1, OwnableUpgradeable, UUPSUpgradeable {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

### <a name="L-2"></a>[L-2] Some tokens may revert when zero value transfers are made

Example: <https://github.com/d-xo/weird-erc20#revert-on-zero-value-transfers>.

In spite of the fact that EIP-20 [states](https://github.com/ethereum/EIPs/blob/46b9b698815abbfa628cd1097311deee77dd45c5/EIPS/eip-20.md?plain=1#L116) that zero-valued transfers must be accepted, some tokens, such as LEND will revert if this is attempted, which may cause transactions that involve other tokens (such as batch operations) to fully revert. Consider skipping the transfer if the amount is zero, which will also save gas.

*Instances (2)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

268:         IERC20(token).transferFrom(from, to, amount);

278:         IERC20(token).transfer(to, amount);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="L-3"></a>[L-3] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:

```solidity
File: contracts/BaseSettlementHandler.sol

126:         token = _token;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

### <a name="L-4"></a>[L-4] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`

Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (4)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

142:                     chain,

143:                     to_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

30:             _msg.payload

43:         return abi.encodePacked(_msg.payload);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

### <a name="L-5"></a>[L-5] Empty Function Body - Consider commenting why

*Instances (3)*:

```solidity
File: contracts/BaseSettlementHandler.sol

135:     function _authorizeUpgrade(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

25:     function _authorizeUpgrade(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

58:     function _authorizeUpgrade(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

### <a name="L-6"></a>[L-6] Initializers could be front-run

Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (23)*:

```solidity
File: contracts/BaseSettlementHandler.sol

113:     function _Settlement_handler_init(

121:         __Ownable_init(_owner);

122:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

82:     function initialize(

90:     ) public initializer {

92:         _Settlement_handler_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

26:     function initialize(

32:     ) public initializer {

33:         __TokenRoles_init(_owner, _operator);

34:         __ERC20_init(_name, _symbol);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

13:     function initialize(

19:     ) public initializer {

20:         __TokenRoles_init(_owner, _operator);

21:         __ERC20_init(_name, _symbol);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

18:     function initialize(address _owner) public initializer {

19:         __Ownable_init(_owner);

20:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

47:     function initialize(

50:     ) public initializer {

51:         __Ownable_init(_owner);

52:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

19:     function __TokenRoles_init(address _owner, address _operator) public {

20:         __Ownable_init(_owner);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="L-7"></a>[L-7] Prevent accidentally burning tokens

Minting and burning tokens to address(0) prevention

*Instances (10)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

130:             _erc20_burn(msg.sender, amount);

326:                     _erc20_mint(

339:                     _erc20_mint(

385:                 _erc20_burn(address(this), create_cross_txs[txid].amount);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

51:         _mint(_msgSender(), value);

63:         _mint(account, value);

71:         _burn(_msgSender(), value);

83:         _burn(account, value);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

33:         _mint(account, amount);

40:         _burn(account, amount);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

### <a name="L-8"></a>[L-8] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`

The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (9)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/ERC20Payload.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/ERC20Payload.sol)

```solidity
File: contracts/libraries/Message.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/Message.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/MessageV1Codec.sol)

### <a name="L-9"></a>[L-9] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`

Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (7)*:

```solidity
File: contracts/BaseSettlementHandler.sol

12: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

4: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

25:     function transferOwnership(address newOwner) public override onlyOwner {

28:         _transferOwnership(newOwner);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="L-10"></a>[L-10] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting

Downcasting from `uint256`/`int256` in Solidity does not revert on overflow. This can result in undesired exploitation or bugs, since developers usually assume that overflows raise errors. [OpenZeppelin's SafeCast library](https://docs.openzeppelin.com/contracts/3.x/api/utils#SafeCast) restores this intuition by reverting the transaction when such an operation overflows. Using this library eliminates an entire class of bugs, so it's recommended to use it always. Some exceptions are acceptable like with the classic `uint256(uint160(address(variable)))`

*Instances (3)*:

```solidity
File: contracts/libraries/AddressCast.sol

23:         result = address(uint160(_address));

23:         result = address(uint160(_address));

29:         result = bytes32(uint256(uint160(_address)));

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/libraries/AddressCast.sol)

### <a name="L-11"></a>[L-11] Unsafe ERC20 operation(s)

*Instances (2)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

268:         IERC20(token).transferFrom(from, to, amount);

278:         IERC20(token).transfer(to, amount);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="L-12"></a>[L-12] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions

See [this](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps) link for a description of this storage variable. While some contracts may not currently be sub-classed, adding the variable now protects against forgetting to add it in the future.

*Instances (31)*:

```solidity
File: contracts/BaseSettlementHandler.sol

11: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

12: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

16: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

19:     OwnableUpgradeable,

20:     UUPSUpgradeable,

21:     AccessControlUpgradeable

122:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

7: import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

14: contract ChakraToken is ERC20Upgradeable, TokenRoles, IERC20Mint, IERC20Burn {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

4: import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

8: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

10: contract ChakraTokenUpgrade is ERC20Upgradeable, TokenRoles {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

7: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

13: contract ERC20CodecV1 is IERC20CodecV1, OwnableUpgradeable, UUPSUpgradeable {

20:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

4: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

8: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

11:     OwnableUpgradeable,

12:     UUPSUpgradeable,

13:     AccessControlUpgradeable

52:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

4: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

5: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

6: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

9:     OwnableUpgradeable,

10:     UUPSUpgradeable,

11:     AccessControlUpgradeable

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="L-13"></a>[L-13] Upgradeable contract not initialized

Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (51)*:

```solidity
File: contracts/BaseSettlementHandler.sol

11: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

12: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

16: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

19:     OwnableUpgradeable,

20:     UUPSUpgradeable,

21:     AccessControlUpgradeable

113:     function _Settlement_handler_init(

121:         __Ownable_init(_owner);

122:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

82:     function initialize(

90:     ) public initializer {

92:         _Settlement_handler_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

7: import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

14: contract ChakraToken is ERC20Upgradeable, TokenRoles, IERC20Mint, IERC20Burn {

26:     function initialize(

32:     ) public initializer {

33:         __TokenRoles_init(_owner, _operator);

34:         __ERC20_init(_name, _symbol);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

4: import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

6: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

8: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

10: contract ChakraTokenUpgrade is ERC20Upgradeable, TokenRoles {

13:     function initialize(

19:     ) public initializer {

20:         __TokenRoles_init(_owner, _operator);

21:         __ERC20_init(_name, _symbol);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

7: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

13: contract ERC20CodecV1 is IERC20CodecV1, OwnableUpgradeable, UUPSUpgradeable {

18:     function initialize(address _owner) public initializer {

19:         __Ownable_init(_owner);

20:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

4: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

5: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

8: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

11:     OwnableUpgradeable,

12:     UUPSUpgradeable,

13:     AccessControlUpgradeable

47:     function initialize(

50:     ) public initializer {

51:         __Ownable_init(_owner);

52:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

4: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

5: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

6: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

9:     OwnableUpgradeable,

10:     UUPSUpgradeable,

11:     AccessControlUpgradeable

19:     function __TokenRoles_init(address _owner, address _operator) public {

20:         __Ownable_init(_owner);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

## Medium Issues

| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 21 |
| [M-2](#M-2) | Return values of `transfer()`/`transferFrom()` not checked | 2 |
| [M-3](#M-3) | Unsafe use of `transfer()`/`transferFrom()`/`approve()`/ with `IERC20` | 2 |

### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact

Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (21)*:

```solidity
File: contracts/BaseSettlementHandler.sol

137:     ) internal override onlyOwner {}

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/BaseSettlementHandler.sol)

```solidity
File: contracts/ChakraSettlementHandler.sol

56:     ) external onlyOwner {

68:     ) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

```solidity
File: contracts/ChakraToken.sol

44:     ) internal override onlyOwner {}

50:     function mint(uint256 value) external onlyRole(OPERATOR_ROLE) {

62:     ) external onlyRole(OPERATOR_ROLE) {

70:     function burn(uint256 value) external onlyRole(OPERATOR_ROLE) {

82:     ) external onlyRole(OPERATOR_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraToken.sol)

```solidity
File: contracts/ChakraTokenUpgradeTest.sol

27:     ) internal override onlyOwner {}

32:     ) external onlyRole(OPERATOR_ROLE) {

39:     ) external onlyRole(OPERATOR_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraTokenUpgradeTest.sol)

```solidity
File: contracts/ERC20CodecV1.sol

29:     ) internal override onlyOwner {}

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ERC20CodecV1.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

60:     ) internal override onlyOwner {}

62:     function add_manager(address _manager) external onlyOwner {

67:     function remove_manager(address _manager) external onlyOwner {

76:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

85:     ) external onlyRole(MANAGER_ROLE) {

94:     ) external virtual onlyRole(MANAGER_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/TokenRoles.sol

25:     function transferOwnership(address newOwner) public override onlyOwner {

31:     function add_operator(address newOperator) external onlyOwner {

36:     function remove_operator(address operator) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/TokenRoles.sol)

### <a name="M-2"></a>[M-2] Return values of `transfer()`/`transferFrom()` not checked

Not all `IERC20` implementations `revert()` when there's a failure in `transfer()`/`transferFrom()`. The function signature has a `boolean` return value and they indicate errors that way instead. By not checking the return value, operations that should have marked as failed, may potentially go through without actually making a payment

*Instances (2)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

268:         IERC20(token).transferFrom(from, to, amount);

278:         IERC20(token).transfer(to, amount);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)

### <a name="M-3"></a>[M-3] Unsafe use of `transfer()`/`transferFrom()`/`approve()`/ with `IERC20`

Some tokens do not implement the ERC20 standard properly but are still accepted by most code that accepts ERC20 tokens.  For example Tether (USDT)'s `transfer()` and `transferFrom()` functions on L1 do not return booleans as the specification requires, and instead have no return value. When these sorts of tokens are cast to `IERC20`, their [function signatures](https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca) do not match and therefore the calls made, revert (see [this](https://gist.github.com/IllIllI000/2b00a32e8f0559e8f386ea4f1800abc5) link for a test case). Use OpenZeppelin's `SafeERC20`'s `safeTransfer()`/`safeTransferFrom()` instead

*Instances (2)*:

```solidity
File: contracts/ChakraSettlementHandler.sol

268:         IERC20(token).transferFrom(from, to, amount);

278:         IERC20(token).transfer(to, amount);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/handler/contracts/ChakraSettlementHandler.sol)
