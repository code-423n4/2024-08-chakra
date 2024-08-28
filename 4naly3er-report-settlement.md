# Report

- [Report](#report)
  - [Gas Optimizations](#gas-optimizations)
    - [\[GAS-1\] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)](#gas-1-a--a--b-is-more-gas-effective-than-a--b-for-state-variables-excluding-arrays-and-mappings)
    - [\[GAS-2\] Comparing to a Boolean constant](#gas-2-comparing-to-a-boolean-constant)
    - [\[GAS-3\] Using bools for storage incurs overhead](#gas-3-using-bools-for-storage-incurs-overhead)
    - [\[GAS-4\] Cache array length outside of loop](#gas-4-cache-array-length-outside-of-loop)
    - [\[GAS-5\] State variables should be cached in stack variables rather than re-reading them from storage](#gas-5-state-variables-should-be-cached-in-stack-variables-rather-than-re-reading-them-from-storage)
    - [\[GAS-6\] Use calldata instead of memory for function arguments that do not get mutated](#gas-6-use-calldata-instead-of-memory-for-function-arguments-that-do-not-get-mutated)
    - [\[GAS-7\] For Operations that will not overflow, you could use unchecked](#gas-7-for-operations-that-will-not-overflow-you-could-use-unchecked)
    - [\[GAS-8\] Use Custom Errors instead of Revert Strings to save Gas](#gas-8-use-custom-errors-instead-of-revert-strings-to-save-gas)
    - [\[GAS-9\] Avoid contract existence checks by using low level calls](#gas-9-avoid-contract-existence-checks-by-using-low-level-calls)
    - [\[GAS-10\] Stack variable used as a cheaper cache for a state variable is only used once](#gas-10-stack-variable-used-as-a-cheaper-cache-for-a-state-variable-is-only-used-once)
    - [\[GAS-11\] Functions guaranteed to revert when called by normal users can be marked `payable`](#gas-11-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)
    - [\[GAS-12\] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)](#gas-12-i-costs-less-gas-compared-to-i-or-i--1-same-for---i-vs-i---or-i---1)
    - [\[GAS-13\] Using `private` rather than `public` for constants, saves gas](#gas-13-using-private-rather-than-public-for-constants-saves-gas)
    - [\[GAS-14\] Use shift right/left instead of division/multiplication if possible](#gas-14-use-shift-rightleft-instead-of-divisionmultiplication-if-possible)
    - [\[GAS-15\] Increments/decrements can be unchecked in for-loops](#gas-15-incrementsdecrements-can-be-unchecked-in-for-loops)
    - [\[GAS-16\] `internal` functions not called by the contract should be removed](#gas-16-internal-functions-not-called-by-the-contract-should-be-removed)
  - [Non Critical Issues](#non-critical-issues)
    - [\[NC-1\] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`](#nc-1-use-stringconcat-or-bytesconcat-instead-of-abiencodepacked)
    - [\[NC-2\] `constant`s should be defined rather than using magic numbers](#nc-2-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-3\] Control structures do not follow the Solidity Style Guide](#nc-3-control-structures-do-not-follow-the-solidity-style-guide)
    - [\[NC-4\] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function](#nc-4-duplicated-requirerevert-checks-should-be-refactored-to-a-modifier-or-function)
    - [\[NC-5\] Events that mark critical parameter changes should contain both the old and the new value](#nc-5-events-that-mark-critical-parameter-changes-should-contain-both-the-old-and-the-new-value)
    - [\[NC-6\] Function ordering does not follow the Solidity style guide](#nc-6-function-ordering-does-not-follow-the-solidity-style-guide)
    - [\[NC-7\] Functions should not be longer than 50 lines](#nc-7-functions-should-not-be-longer-than-50-lines)
    - [\[NC-8\] Change int to int256](#nc-8-change-int-to-int256)
    - [\[NC-9\] Lack of checks in setters](#nc-9-lack-of-checks-in-setters)
    - [\[NC-10\] NatSpec is completely non-existent on functions that should have them](#nc-10-natspec-is-completely-non-existent-on-functions-that-should-have-them)
    - [\[NC-11\] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor](#nc-11-use-a-modifier-instead-of-a-requireif-statement-for-a-special-msgsender-actor)
    - [\[NC-12\] Constant state variables defined more than once](#nc-12-constant-state-variables-defined-more-than-once)
    - [\[NC-13\] Consider using named mappings](#nc-13-consider-using-named-mappings)
    - [\[NC-14\] Take advantage of Custom Error's return value property](#nc-14-take-advantage-of-custom-errors-return-value-property)
    - [\[NC-15\] Contract does not follow the Solidity style guide's suggested layout ordering](#nc-15-contract-does-not-follow-the-solidity-style-guides-suggested-layout-ordering)
    - [\[NC-16\] Internal and private variables and functions names should begin with an underscore](#nc-16-internal-and-private-variables-and-functions-names-should-begin-with-an-underscore)
    - [\[NC-17\] Event is missing `indexed` fields](#nc-17-event-is-missing-indexed-fields)
    - [\[NC-18\] `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings](#nc-18-override-function-arguments-that-are-unused-should-have-the-variable-name-removed-or-commented-out-to-avoid-compiler-warnings)
    - [\[NC-19\] `public` functions not called by the contract should be declared `external` instead](#nc-19-public-functions-not-called-by-the-contract-should-be-declared-external-instead)
    - [\[NC-20\] Variables need not be initialized to zero](#nc-20-variables-need-not-be-initialized-to-zero)
  - [Low Issues](#low-issues)
    - [\[L-1\] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`](#l-1-abiencodepacked-should-not-be-used-with-dynamic-types-when-passing-the-result-to-a-hash-function-such-as-keccak256)
    - [\[L-2\] Initializers could be front-run](#l-2-initializers-could-be-front-run)
    - [\[L-3\] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`](#l-3-solidity-version-0820-may-not-work-on-other-chains-due-to-push0)
    - [\[L-4\] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`](#l-4-use-ownable2steptransferownership-instead-of-ownabletransferownership)
    - [\[L-5\] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting](#l-5-consider-using-openzeppelins-safecast-library-to-prevent-unexpected-overflows-when-downcasting)
    - [\[L-6\] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions](#l-6-upgradeable-contract-is-missing-a-__gap50-storage-variable-to-allow-for-new-storage-variables-in-later-versions)
    - [\[L-7\] Upgradeable contract not initialized](#l-7-upgradeable-contract-not-initialized)
  - [Medium Issues](#medium-issues)
    - [\[M-1\] Centralization Risk for trusted owners](#m-1-centralization-risk-for-trusted-owners)
      - [Impact](#impact)

## Gas Optimizations

| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 5 |
| [GAS-2](#GAS-2) | Comparing to a Boolean constant | 7 |
| [GAS-3](#GAS-3) | Using bools for storage incurs overhead | 2 |
| [GAS-4](#GAS-4) | Cache array length outside of loop | 1 |
| [GAS-5](#GAS-5) | State variables should be cached in stack variables rather than re-reading them from storage | 2 |
| [GAS-6](#GAS-6) | Use calldata instead of memory for function arguments that do not get mutated | 17 |
| [GAS-7](#GAS-7) | For Operations that will not overflow, you could use unchecked | 43 |
| [GAS-8](#GAS-8) | Use Custom Errors instead of Revert Strings to save Gas | 3 |
| [GAS-9](#GAS-9) | Avoid contract existence checks by using low level calls | 1 |
| [GAS-10](#GAS-10) | Stack variable used as a cheaper cache for a state variable is only used once | 2 |
| [GAS-11](#GAS-11) | Functions guaranteed to revert when called by normal users can be marked `payable` | 6 |
| [GAS-12](#GAS-12) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 1 |
| [GAS-13](#GAS-13) | Using `private` rather than `public` for constants, saves gas | 2 |
| [GAS-14](#GAS-14) | Use shift right/left instead of division/multiplication if possible | 2 |
| [GAS-15](#GAS-15) | Increments/decrements can be unchecked in for-loops | 1 |
| [GAS-16](#GAS-16) | `internal` functions not called by the contract should be removed | 14 |

### <a name="GAS-1"></a>[GAS-1] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)

This saves **16 gas per instance.**

*Instances (5)*:

```solidity
File: contracts/BaseSettlement.sol

95:         validator_count += 1;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

118:         nonce_manager[from_address] += 1;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

94:         nonce_manager[from_address] += 1;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

116:         validator_count += 1;

204:         for (uint256 i = 0; i < len; i += 65) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-2"></a>[GAS-2] Comparing to a Boolean constant

Comparing to a constant (`true` or `false`) is a bit more expensive than directly checking the returned boolean value.

Consider using `if(directValue)` instead of `if(directValue == true)` and `if(!directValue)` instead of `if(directValue == false)`

*Instances (7)*:

```solidity
File: contracts/BaseSettlement.sol

91:             chakra_validators[validator] == false,

108:             chakra_validators[validator] == true,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

228:         if (result == true) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

194:         if (result == true) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

48:         require(validators[msg.sender] == true, "Not validator");

114:         require(validators[validator] == false, "Validator already exists");

128:         require(validators[validator] == true, "Validator does not exists");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-3"></a>[GAS-3] Using bools for storage incurs overhead

Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

42:     mapping(address => bool) public chakra_validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

43:     mapping(address => bool) public validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-4"></a>[GAS-4] Cache array length outside of loop

If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (1)*:

```solidity
File: contracts/BaseSettlement.sol

66:         for (uint256 i = 0; i < _managers.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

### <a name="GAS-5"></a>[GAS-5] State variables should be cached in stack variables rather than re-reading them from storage

The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

126:         emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

144:         emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-6"></a>[GAS-6] Use calldata instead of memory for function arguments that do not get mutated

When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop.

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one.

 *Saves 60 gas per instance*

*Instances (17)*:

```solidity
File: contracts/BaseSettlement.sol

55:         string memory _chain_name,

58:         address[] memory _managers,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

86:         string memory _chain_name,

89:         address[] memory _managers,

112:         string memory to_chain,

172:         string memory from_chain,

258:         string memory from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

70:         string memory _chain_name,

73:         address[] memory _managers,

88:         string memory to_chain,

138:         string memory from_chain,

214:         string memory from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/interfaces/ISettlement.sol

17:         string memory to_chain,

38:         string memory from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlement.sol)

```solidity
File: contracts/interfaces/ISettlementHandler.sol

18:         string memory from_chain,

37:         string memory from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlementHandler.sol)

```solidity
File: contracts/interfaces/ISettlementSignatureVerifier.sol

42:         bytes memory signatures,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlementSignatureVerifier.sol)

### <a name="GAS-7"></a>[GAS-7] For Operations that will not overflow, you could use unchecked

*Instances (43)*:

```solidity
File: contracts/BaseSettlement.sol

5: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

6: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

7: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

8: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

66:         for (uint256 i = 0; i < _managers.length; i++) {

95:         validator_count += 1;

112:         validator_count -= 1;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

4: import {BaseSettlement} from "contracts/BaseSettlement.sol";

5: import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";

6: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

7: import {PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";

118:         nonce_manager[from_address] += 1;

125:                     contract_chain_name, // from chain

127:                     from_address, // msg.sender address

128:                     from_handler, // settlement handler address

178:         uint8 sign_type, // validators signature type /  multisig or bls sr25519

179:         bytes calldata signatures // signature array

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

4: import {BaseSettlement} from "contracts/BaseSettlement.sol";

5: import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";

6: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

7: import {PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";

94:         nonce_manager[from_address] += 1;

144:         uint8 sign_type, // validators signature type /  multisig or bls sr25519

145:         bytes calldata signatures // signature array

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

5: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

6: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

7: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

8: import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

9: import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

10: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

116:         validator_count += 1;

130:         validator_count -= 1;

204:         for (uint256 i = 0; i < len; i += 65) {

205:             bytes memory sig = signatures[i:i + 65];

207:                 validators[msgHash.recover(sig)] && ++m >= required_validators

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/interfaces/ISettlement.sol

4: import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";

5: import {PayloadType} from "contracts/libraries/Message.sol";

44:         uint8 sign_type, // validators signature type /  multisig or bls sr25519

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlement.sol)

```solidity
File: contracts/interfaces/ISettlementHandler.sol

4: import {PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlementHandler.sol)

```solidity
File: contracts/libraries/AddressCast.sol

69:             uint256 offset = 256 - _size * 8;

95:             uint256 offset = 32 - _addressBytes.length;

96:             result = result >> (offset * 8);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

4: import {Message, PayloadType} from "contracts/libraries/Message.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

### <a name="GAS-8"></a>[GAS-8] Use Custom Errors instead of Revert Strings to save Gas

Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (3)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

48:         require(validators[msg.sender] == true, "Not validator");

114:         require(validators[validator] == false, "Validator already exists");

128:         require(validators[validator] == true, "Validator does not exists");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-9"></a>[GAS-9] Avoid contract existence checks by using low level calls

Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (1)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

207:                 validators[msgHash.recover(sig)] && ++m >= required_validators

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-10"></a>[GAS-10] Stack variable used as a cheaper cache for a state variable is only used once

If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

124:         uint256 old = required_validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

142:         uint256 old = required_validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-11"></a>[GAS-11] Functions guaranteed to revert when called by normal users can be marked `payable`

If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (6)*:

```solidity
File: contracts/BaseSettlement.sol

88:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

149:     function add_manager(address _manager) external onlyOwner {

159:     function remove_manager(address _manager) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

83:     function add_manager(address _manager) external onlyOwner {

93:     function remove_manager(address _manager) external onlyOwner {

113:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-12"></a>[GAS-12] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)

Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (1)*:

```solidity
File: contracts/BaseSettlement.sol

66:         for (uint256 i = 0; i < _managers.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

### <a name="GAS-13"></a>[GAS-13] Using `private` rather than `public` for constants, saves gas

If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

28:     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

37:     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="GAS-14"></a>[GAS-14] Use shift right/left instead of division/multiplication if possible

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

69:             uint256 offset = 256 - _size * 8;

96:             result = result >> (offset * 8);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

### <a name="GAS-15"></a>[GAS-15] Increments/decrements can be unchecked in for-loops

In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (1)*:

```solidity
File: contracts/BaseSettlement.sol

66:         for (uint256 i = 0; i < _managers.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

### <a name="GAS-16"></a>[GAS-16] `internal` functions not called by the contract should be removed

If the functions are required by an interface, the contract should inherit from that interface and use the `override` keyword

*Instances (14)*:

```solidity
File: contracts/libraries/AddressCast.sol

12:     function to_uint256(

22:     function to_address(

32:     function to_address(

42:     function to_bytes32(

55:     function to_bytes(

83:     function to_bytes32(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

23:     function encode(

38:     function encode_message_header(

48:     function encode_payload(

58:     function header(

68:     function version(bytes calldata _msg) internal pure returns (uint8) {

76:     function id(bytes calldata _msg) internal pure returns (uint64) {

84:     function payload_type(

105:     function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

## Non Critical Issues

| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 9 |
| [NC-2](#NC-2) | `constant`s should be defined rather than using magic numbers | 10 |
| [NC-3](#NC-3) | Control structures do not follow the Solidity Style Guide | 32 |
| [NC-4](#NC-4) | Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function | 8 |
| [NC-5](#NC-5) | Events that mark critical parameter changes should contain both the old and the new value | 2 |
| [NC-6](#NC-6) | Function ordering does not follow the Solidity style guide | 4 |
| [NC-7](#NC-7) | Functions should not be longer than 50 lines | 27 |
| [NC-8](#NC-8) | Change int to int256 | 1 |
| [NC-9](#NC-9) | Lack of checks in setters | 1 |
| [NC-10](#NC-10) | NatSpec is completely non-existent on functions that should have them | 3 |
| [NC-11](#NC-11) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 3 |
| [NC-12](#NC-12) | Constant state variables defined more than once | 2 |
| [NC-13](#NC-13) | Consider using named mappings | 7 |
| [NC-14](#NC-14) | Take advantage of Custom Error's return value property | 2 |
| [NC-15](#NC-15) | Contract does not follow the Solidity style guide's suggested layout ordering | 2 |
| [NC-16](#NC-16) | Internal and private variables and functions names should begin with an underscore | 22 |
| [NC-17](#NC-17) | Event is missing `indexed` fields | 6 |
| [NC-18](#NC-18) | `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings | 1 |
| [NC-19](#NC-19) | `public` functions not called by the contract should be declared `external` instead | 4 |
| [NC-20](#NC-20) | Variables need not be initialized to zero | 3 |

### <a name="NC-1"></a>[NC-1] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`

Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a`bytes`data mixed in the concatenation)`)

*Instances (9)*:

```solidity
File: contracts/ChakraSettlement.sol

124:                 abi.encodePacked(

184:                 abi.encodePacked(

294:             abi.encodePacked(txid, from_handler, to_handler, status)

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

100:                 abi.encodePacked(

150:                 abi.encodePacked(

250:             abi.encodePacked(txid, from_handler, to_handler, status)

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

26:         encodedMessage = abi.encodePacked(

41:         return abi.encodePacked(MESSAGE_VERSION, _msg.id, _msg.payload_type);

51:         return abi.encodePacked(_msg.payload);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

### <a name="NC-2"></a>[NC-2] `constant`s should be defined rather than using magic numbers

Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (10)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

198:             signatures.length % 65 == 0,

199:             "Signature length must be a multiple of 65"

204:         for (uint256 i = 0; i < len; i += 65) {

205:             bytes memory sig = signatures[i:i + 65];

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

60:         if (_size == 0 || _size > 32)

69:             uint256 offset = 256 - _size * 8;

72:                 mstore(add(result, 32), shl(offset, _addressBytes32))

87:         if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

95:             uint256 offset = 32 - _addressBytes.length;

96:             result = result >> (offset * 8);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

### <a name="NC-3"></a>[NC-3] Control structures do not follow the Solidity Style Guide

See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (32)*:

```solidity
File: contracts/BaseSettlement.sol

8: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

38:     ISettlementSignatureVerifier public signature_verifier;

60:         address _signature_verifier

73:         signature_verifier = ISettlementSignatureVerifier(_signature_verifier);

89:         signature_verifier.add_validator(validator);

106:         signature_verifier.remove_validator(validator);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

6: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

91:         address _verify_contract

99:             _verify_contract

195:                 signature_verifier.verify(message_hash, signatures, sign_type),

265:         verifySignature(

285:     function verifySignature(

298:             signature_verifier.verify(message_hash, signatures, sign_type),

317:         if (

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

6: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

75:         address _verify_contract

83:             _verify_contract

161:                 signature_verifier.verify(message_hash, signatures, sign_type),

221:         verifySignature(

241:     function verifySignature(

254:             signature_verifier.verify(message_hash, signatures, sign_type),

273:         if (

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

5: import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

16: contract SettlementSignatureVerifier is

20:     ISettlementSignatureVerifier

174:     function verify(

180:             return verifyECDSA(msgHash, signatures);

193:     function verifyECDSA(

206:             if (

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/interfaces/ISettlementSignatureVerifier.sol

40:     function verify(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

60:         if (_size == 0 || _size > 32)

87:         if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

### <a name="NC-4"></a>[NC-4] Duplicated `require()`/`revert()` Checks Should Be Refactored To A Modifier Or Function

*Instances (8)*:

```solidity
File: contracts/ChakraSettlement.sol

194:             require(

199:             require(

297:         require(

312:         require(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

160:             require(

165:             require(

253:         require(

268:         require(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

### <a name="NC-5"></a>[NC-5] Events that mark critical parameter changes should contain both the old and the new value

This should especially be done if the new value is not required to be different from the old value

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

121:     function set_required_validators_num(
             uint256 _required_validators
         ) external onlyRole(MANAGER_ROLE) {
             uint256 old = required_validators;
             required_validators = _required_validators;
             emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

139:     function set_required_validators_num(
             uint256 _required_validators
         ) external virtual onlyRole(MANAGER_ROLE) {
             uint256 old = required_validators;
             required_validators = _required_validators;
             emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-6"></a>[NC-6] Function ordering does not follow the Solidity style guide

According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (4)*:

```solidity
File: contracts/BaseSettlement.sol

1: 
   Current order:
   public _Settlement_init
   internal _authorizeUpgrade
   external add_validator
   external remove_validator
   external set_required_validators_num
   external is_validator
   external view_required_validators_num
   external add_manager
   external remove_manager
   external is_manager
   external view_nonce
   public version
   
   Suggested order:
   external add_validator
   external remove_validator
   external set_required_validators_num
   external is_validator
   external view_required_validators_num
   external add_manager
   external remove_manager
   external is_manager
   external view_nonce
   public _Settlement_init
   public version
   internal _authorizeUpgrade

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

1: 
   Current order:
   public initialize
   external send_cross_chain_msg
   external receive_cross_chain_msg
   external receive_cross_chain_callback
   internal verifySignature
   internal processCrossChainCallback
   internal emitCrossChainResult
   
   Suggested order:
   external send_cross_chain_msg
   external receive_cross_chain_msg
   external receive_cross_chain_callback
   public initialize
   internal verifySignature
   internal processCrossChainCallback
   internal emitCrossChainResult

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

1: 
   Current order:
   public initialize
   external send_cross_chain_msg
   external receive_cross_chain_msg
   external receive_cross_chain_callback
   internal verifySignature
   internal processCrossChainCallback
   internal emitCrossChainResult
   public version
   
   Suggested order:
   external send_cross_chain_msg
   external receive_cross_chain_msg
   external receive_cross_chain_callback
   public initialize
   public version
   internal verifySignature
   internal processCrossChainCallback
   internal emitCrossChainResult

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

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

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-7"></a>[NC-7] Functions should not be longer than 50 lines

Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability

*Instances (27)*:

```solidity
File: contracts/BaseSettlement.sol

88:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

133:     function is_validator(address _validator) external view returns (bool) {

140:     function view_required_validators_num() external view returns (uint256) {

149:     function add_manager(address _manager) external onlyOwner {

159:     function remove_manager(address _manager) external onlyOwner {

168:     function is_manager(address _manager) external view returns (bool) {

176:     function view_nonce(address account) external view returns (uint256) {

183:     function version() public pure virtual returns (string memory) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

333:     function emitCrossChainResult(uint256 txid) internal {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

289:     function emitCrossChainResult(uint256 txid) internal {

301:     function version() public pure override returns (string memory) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

83:     function add_manager(address _manager) external onlyOwner {

93:     function remove_manager(address _manager) external onlyOwner {

104:     function is_manager(address _manager) external view returns (bool) {

113:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

153:     function is_validator(address _validator) external view returns (bool) {

162:     function view_required_validators_num() external view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/interfaces/IERC20Burn.sol

28:     function burn_from(address account, uint256 value) external;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/IERC20Burn.sol)

```solidity
File: contracts/interfaces/IERC20Mint.sol

28:     function mint_to(address account, uint256 value) external;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/IERC20Mint.sol)

```solidity
File: contracts/interfaces/ISettlementSignatureVerifier.sol

9:     function add_validator(address validator) external;

15:     function remove_validator(address validator) external;

21:     function is_validator(address _validator) external view returns (bool);

27:     function set_required_validators_num(uint256 _required_validators) external;

32:     function view_required_validators_num() external view returns (uint256);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/ISettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

68:     function version(bytes calldata _msg) internal pure returns (uint8) {

76:     function id(bytes calldata _msg) internal pure returns (uint64) {

105:     function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

### <a name="NC-8"></a>[NC-8] Change int to int256

Throughout the code base, some variables are declared as `int`. To favor explicitness, consider changing all instances of `int` to `int256`

*Instances (1)*:

```solidity
File: contracts/interfaces/IERC20Mint.sol

9: interface IERC20Mint {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/interfaces/IERC20Mint.sol)

### <a name="NC-9"></a>[NC-9] Lack of checks in setters

Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (1)*:

```solidity
File: contracts/BaseSettlement.sol

121:     function set_required_validators_num(
             uint256 _required_validators
         ) external onlyRole(MANAGER_ROLE) {
             uint256 old = required_validators;
             required_validators = _required_validators;
             emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

### <a name="NC-10"></a>[NC-10] NatSpec is completely non-existent on functions that should have them

Public and external functions that aren't view or pure should have NatSpec comments

*Instances (3)*:

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

69:     function initialize(

136:     function receive_cross_chain_msg(

212:     function receive_cross_chain_callback(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

### <a name="NC-11"></a>[NC-11] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor

If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (3)*:

```solidity
File: contracts/BaseSettlement.sol

126:         emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

48:         require(validators[msg.sender] == true, "Not validator");

144:         emit RequiredValidatorsChanged(msg.sender, old, required_validators);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-12"></a>[NC-12] Constant state variables defined more than once

Rather than redefining state variable constant, consider using a library to store all constants as this will prevent data redundancy

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

28:     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

37:     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-13"></a>[NC-13] Consider using named mappings

Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (7)*:

```solidity
File: contracts/BaseSettlement.sol

41:     mapping(address => uint256) public nonce_manager;

42:     mapping(address => bool) public chakra_validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

11:     mapping(uint256 => CreatedCrossChainTx) public create_cross_txs;

12:     mapping(uint256 => ReceivedCrossChainTx) public receive_cross_txs;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

10:     mapping(uint256 => CreatedCrossChainTx) public create_cross_txs;

11:     mapping(uint256 => ReceivedCrossChainTx) public receive_cross_txs;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

43:     mapping(address => bool) public validators;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-14"></a>[NC-14] Take advantage of Custom Error's return value property

An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (2)*:

```solidity
File: contracts/libraries/AddressCast.sol

61:             revert AddressCast_InvalidSizeForAddress();

87:         if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

### <a name="NC-15"></a>[NC-15] Contract does not follow the Solidity style guide's suggested layout ordering

The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

1: 
   Current order:
   EventDefinition.ManagerAdded
   EventDefinition.ManagerRemoved
   EventDefinition.ValidatorAdded
   EventDefinition.ValidatorRemoved
   EventDefinition.RequiredValidatorsChanged
   VariableDeclaration.MANAGER_ROLE
   VariableDeclaration.chain_id
   VariableDeclaration.contract_chain_name
   VariableDeclaration.required_validators
   VariableDeclaration.signature_verifier
   VariableDeclaration.nonce_manager
   VariableDeclaration.chakra_validators
   VariableDeclaration.validator_count
   FunctionDefinition._Settlement_init
   FunctionDefinition._authorizeUpgrade
   FunctionDefinition.add_validator
   FunctionDefinition.remove_validator
   FunctionDefinition.set_required_validators_num
   FunctionDefinition.is_validator
   FunctionDefinition.view_required_validators_num
   FunctionDefinition.add_manager
   FunctionDefinition.remove_manager
   FunctionDefinition.is_manager
   FunctionDefinition.view_nonce
   FunctionDefinition.version
   
   Suggested order:
   VariableDeclaration.MANAGER_ROLE
   VariableDeclaration.chain_id
   VariableDeclaration.contract_chain_name
   VariableDeclaration.required_validators
   VariableDeclaration.signature_verifier
   VariableDeclaration.nonce_manager
   VariableDeclaration.chakra_validators
   VariableDeclaration.validator_count
   EventDefinition.ManagerAdded
   EventDefinition.ManagerRemoved
   EventDefinition.ValidatorAdded
   EventDefinition.ValidatorRemoved
   EventDefinition.RequiredValidatorsChanged
   FunctionDefinition._Settlement_init
   FunctionDefinition._authorizeUpgrade
   FunctionDefinition.add_validator
   FunctionDefinition.remove_validator
   FunctionDefinition.set_required_validators_num
   FunctionDefinition.is_validator
   FunctionDefinition.view_required_validators_num
   FunctionDefinition.add_manager
   FunctionDefinition.remove_manager
   FunctionDefinition.is_manager
   FunctionDefinition.view_nonce
   FunctionDefinition.version

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

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

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-16"></a>[NC-16] Internal and private variables and functions names should begin with an underscore

According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (22)*:

```solidity
File: contracts/ChakraSettlement.sol

285:     function verifySignature(

303:     function processCrossChainCallback(

333:     function emitCrossChainResult(uint256 txid) internal {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

241:     function verifySignature(

259:     function processCrossChainCallback(

289:     function emitCrossChainResult(uint256 txid) internal {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

193:     function verifyECDSA(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

12:     function to_uint256(

22:     function to_address(

32:     function to_address(

42:     function to_bytes32(

55:     function to_bytes(

83:     function to_bytes32(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

23:     function encode(

38:     function encode_message_header(

48:     function encode_payload(

58:     function header(

68:     function version(bytes calldata _msg) internal pure returns (uint8) {

76:     function id(bytes calldata _msg) internal pure returns (uint64) {

84:     function payload_type(

95:     function payload(

105:     function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

### <a name="NC-17"></a>[NC-17] Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (6)*:

```solidity
File: contracts/ChakraSettlement.sol

43:     event CrossChainMsg(

55:     event CrossChainHandleResult(

66:     event CrossChainResult(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

36:     event CrossChainMsg(

48:     event CrossChainHandleResult(

59:     event CrossChainResult(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

### <a name="NC-18"></a>[NC-18] `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings

*Instances (1)*:

```solidity
File: contracts/SettlementSignatureVerifier.sol

75:         address newImplementation

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-19"></a>[NC-19] `public` functions not called by the contract should be declared `external` instead

*Instances (4)*:

```solidity
File: contracts/BaseSettlement.sol

54:     function _Settlement_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

85:     function initialize(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

69:     function initialize(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

58:     function initialize(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="NC-20"></a>[NC-20] Variables need not be initialized to zero

The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (3)*:

```solidity
File: contracts/BaseSettlement.sol

66:         for (uint256 i = 0; i < _managers.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

203:         uint256 m = 0;

204:         for (uint256 i = 0; i < len; i += 65) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

## Low Issues

| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 9 |
| [L-2](#L-2) | Initializers could be front-run | 13 |
| [L-3](#L-3) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 6 |
| [L-4](#L-4) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 2 |
| [L-5](#L-5) | Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting | 3 |
| [L-6](#L-6) | Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions | 14 |
| [L-7](#L-7) | Upgradeable contract not initialized | 25 |

### <a name="L-1"></a>[L-1] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`

Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (9)*:

```solidity
File: contracts/ChakraSettlement.sol

125:                     contract_chain_name, // from chain

126:                     to_chain,

186:                     from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

101:                     contract_chain_name,

102:                     to_chain,

108:                     payload

152:                     from_chain,

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

30:             _msg.payload

51:         return abi.encodePacked(_msg.payload);

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

### <a name="L-2"></a>[L-2] Initializers could be front-run

Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (13)*:

```solidity
File: contracts/BaseSettlement.sol

54:     function _Settlement_init(

62:         __Ownable_init(_owner);

63:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

85:     function initialize(

92:     ) public initializer {

93:         _Settlement_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

69:     function initialize(

76:     ) public initializer {

77:         _Settlement_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

58:     function initialize(

61:     ) public initializer {

62:         __Ownable_init(_owner);

63:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="L-3"></a>[L-3] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`

The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (6)*:

```solidity
File: contracts/ChakraSettlement.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

```solidity
File: contracts/libraries/AddressCast.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

```solidity
File: contracts/libraries/Message.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/Message.sol)

```solidity
File: contracts/libraries/MessageV1Codec.sol

2: pragma solidity ^0.8.24;

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/MessageV1Codec.sol)

### <a name="L-4"></a>[L-4] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`

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

*Instances (2)*:

```solidity
File: contracts/BaseSettlement.sol

6: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

7: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="L-5"></a>[L-5] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting

Downcasting from `uint256`/`int256` in Solidity does not revert on overflow. This can result in undesired exploitation or bugs, since developers usually assume that overflows raise errors. [OpenZeppelin's SafeCast library](https://docs.openzeppelin.com/contracts/3.x/api/utils#SafeCast) restores this intuition by reverting the transaction when such an operation overflows. Using this library eliminates an entire class of bugs, so it's recommended to use it always. Some exceptions are acceptable like with the classic `uint256(uint160(address(variable)))`

*Instances (3)*:

```solidity
File: contracts/libraries/AddressCast.sol

35:         result = address(uint160(_address));

35:         result = address(uint160(_address));

45:         result = bytes32(uint256(uint160(_address)));

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/libraries/AddressCast.sol)

### <a name="L-6"></a>[L-6] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions

See [this](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps) link for a description of this storage variable. While some contracts may not currently be sub-classed, adding the variable now protects against forgetting to add it in the future.

*Instances (14)*:

```solidity
File: contracts/BaseSettlement.sol

5: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

6: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

7: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

12:     OwnableUpgradeable,

13:     UUPSUpgradeable,

14:     AccessControlUpgradeable

63:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

6: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

7: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

10: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

17:     OwnableUpgradeable,

18:     UUPSUpgradeable,

19:     AccessControlUpgradeable,

63:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

### <a name="L-7"></a>[L-7] Upgradeable contract not initialized

Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (25)*:

```solidity
File: contracts/BaseSettlement.sol

5: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

6: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

7: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

12:     OwnableUpgradeable,

13:     UUPSUpgradeable,

14:     AccessControlUpgradeable

54:     function _Settlement_init(

62:         __Ownable_init(_owner);

63:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/ChakraSettlement.sol

85:     function initialize(

92:     ) public initializer {

93:         _Settlement_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlement.sol)

```solidity
File: contracts/ChakraSettlementUpgradeTest.sol

69:     function initialize(

76:     ) public initializer {

77:         _Settlement_init(

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/ChakraSettlementUpgradeTest.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

6: import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

7: import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

10: import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

17:     OwnableUpgradeable,

18:     UUPSUpgradeable,

19:     AccessControlUpgradeable,

58:     function initialize(

61:     ) public initializer {

62:         __Ownable_init(_owner);

63:         __UUPSUpgradeable_init();

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)

## Medium Issues

| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 12 |

### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact

Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (12)*:

```solidity
File: contracts/BaseSettlement.sol

82:     ) internal override onlyOwner {}

88:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

105:     ) external onlyRole(MANAGER_ROLE) {

123:     ) external onlyRole(MANAGER_ROLE) {

149:     function add_manager(address _manager) external onlyOwner {

159:     function remove_manager(address _manager) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/BaseSettlement.sol)

```solidity
File: contracts/SettlementSignatureVerifier.sol

76:     ) internal override onlyOwner {}

83:     function add_manager(address _manager) external onlyOwner {

93:     function remove_manager(address _manager) external onlyOwner {

113:     function add_validator(address validator) external onlyRole(MANAGER_ROLE) {

127:     ) external onlyRole(MANAGER_ROLE) {

141:     ) external virtual onlyRole(MANAGER_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-08-chakra/blob/main/solidity/settlement/contracts/SettlementSignatureVerifier.sol)
