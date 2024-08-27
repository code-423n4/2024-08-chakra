// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

abstract contract BaseSettlementTest is
    OwnableUpgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable
{
    /**
     * @notice The chain id of the settlement contract.
     */
    uint256 public chain_id;
    string public contract_chain_name;

    ISettlementSignatureVerifier public signature_verifier;

    mapping(address => uint256) public nonce_manager;
    uint256 public validator_count;

    function _Settlement_init(
        string memory _chain_name,
        uint256 _chain_id,
        address _owner,
        ISettlementSignatureVerifier _signature_verifier
    ) public {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);

        chain_id = _chain_id;

        contract_chain_name = _chain_name;
        signature_verifier = _signature_verifier;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function view_nonce(address acount) external view returns (uint256) {
        return nonce_manager[acount];
    }

    function version() public pure returns (string memory) {
        return "0.1.0";
    }
}
