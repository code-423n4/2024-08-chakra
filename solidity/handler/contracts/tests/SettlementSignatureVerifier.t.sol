// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

pragma solidity ^0.8.24;

import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";
import {AddressCast} from "contracts/libraries/AddressCast.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract SettlementSignatureVerifierTest is
    ISettlementSignatureVerifier,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function verify(
        bytes32 /** msg_hash */,
        bytes calldata /**signatures */,
        address[] calldata /**signers */,
        uint8 /**sign_type */
    ) external pure returns (bool) {
        return true;
    }
}
