// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20Mint} from "contracts/interfaces/IERC20Mint.sol";
import {IERC20Burn} from "contracts/interfaces/IERC20Burn.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {TokenRoles} from "contracts/tests/TokenRoles.t.sol";

contract MyToken is ERC20Upgradeable, TokenRoles, IERC20Mint, IERC20Burn {
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

    function mint(uint256 value) external onlyRole(OPERATOR_ROLE) {
        _mint(_msgSender(), value);
    }

    function mint_to(
        address account,
        uint256 value
    ) external onlyRole(OPERATOR_ROLE) {
        _mint(account, value);
    }

    function burn(uint256 value) external onlyRole(OPERATOR_ROLE) {
        _burn(_msgSender(), value);
    }

    function burn_from(
        address account,
        uint256 value
    ) external onlyRole(OPERATOR_ROLE) {
        _burn(account, value);
    }

    function decimals() public view override returns (uint8) {
        return set_decimals;
    }

    function version() public pure returns (string memory) {
        return "0.0.1";
    }
}
