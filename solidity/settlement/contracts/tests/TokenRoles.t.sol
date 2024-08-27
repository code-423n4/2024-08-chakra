// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

abstract contract TokenRoles is
    OwnableUpgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable
{
    event OperatorAdded(address indexed owner, address indexed operator);

    event OperatorRemoved(address indexed owner, address indexed operator);

    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    function __TokenRoles_init(address _owner, address _operator) public {
        __Ownable_init(_owner);
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);
        _grantRole(OPERATOR_ROLE, _operator);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(DEFAULT_ADMIN_ROLE, newOwner);
        _transferOwnership(newOwner);
    }

    function add_operator(address newOperator) external onlyOwner {
        _grantRole(OPERATOR_ROLE, newOperator);
        emit OperatorAdded(msg.sender, newOperator);
    }

    function remove_operator(address operator) external onlyOwner {
        _revokeRole(OPERATOR_ROLE, operator);
        emit OperatorRemoved(msg.sender, operator);
    }

    function is_operator(address account) public view returns (bool) {
        return hasRole(OPERATOR_ROLE, account);
    }
}
