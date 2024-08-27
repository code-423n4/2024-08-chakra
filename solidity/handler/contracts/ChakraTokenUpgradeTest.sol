// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {TokenRoles} from "contracts/TokenRoles.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract ChakraTokenUpgrade is ERC20Upgradeable, TokenRoles {
    uint8 set_decimals;

    function initialize(
        address _owner,
        address _operator,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) public initializer {
        __TokenRoles_init(_owner, _operator);
        __ERC20_init(_name, _symbol);
        set_decimals = _decimals;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function mint(
        address account,
        uint256 amount
    ) external onlyRole(OPERATOR_ROLE) {
        _mint(account, amount);
    }

    function burn(
        address account,
        uint256 amount
    ) external onlyRole(OPERATOR_ROLE) {
        _burn(account, amount);
    }

    function decimals() public view override returns (uint8) {
        return set_decimals;
    }

    function version() public pure returns (string memory) {
        return "0.0.2";
    }
}
