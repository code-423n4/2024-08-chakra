// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Import statements for required interfaces and contracts
import {IERC20Mint} from "contracts/interfaces/IERC20Mint.sol";
import {IERC20Burn} from "contracts/interfaces/IERC20Burn.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {TokenRoles} from "contracts/TokenRoles.sol";

/**
 * @title ChakraToken
 * @dev An upgradeable ERC20 token with minting and burning capabilities
 */
contract ChakraToken is ERC20Upgradeable, TokenRoles, IERC20Mint, IERC20Burn {
    // Custom decimals for the token
    uint8 set_decimals;

    /**
     * @dev Initializes the contract
     * @param _owner The address of the contract owner
     * @param _operator The address of the operator
     * @param _name The name of the token
     * @param _symbol The symbol of the token
     * @param _decimals The number of decimals for the token
     */
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

    /**
     * @dev Function to authorize an upgrade
     * @param newImplementation Address of the new implementation
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Mints tokens to the caller's address
     * @param value The amount of tokens to mint
     */
    function mint(uint256 value) external onlyRole(OPERATOR_ROLE) {
        _mint(_msgSender(), value);
    }

    /**
     * @dev Mints tokens to a specified account
     * @param account The address to mint tokens to
     * @param value The amount of tokens to mint
     */
    function mint_to(
        address account,
        uint256 value
    ) external onlyRole(OPERATOR_ROLE) {
        _mint(account, value);
    }

    /**
     * @dev Burns tokens from the caller's address
     * @param value The amount of tokens to burn
     */
    function burn(uint256 value) external onlyRole(OPERATOR_ROLE) {
        _burn(_msgSender(), value);
    }

    /**
     * @dev Burns tokens from a specified account
     * @param account The address to burn tokens from
     * @param value The amount of tokens to burn
     */
    function burn_from(
        address account,
        uint256 value
    ) external onlyRole(OPERATOR_ROLE) {
        _burn(account, value);
    }

    /**
     * @dev Returns the number of decimals for the token
     * @return uint8 The number of decimals
     */
    function decimals() public view override returns (uint8) {
        return set_decimals;
    }

    /**
     * @dev Returns the version of the contract
     * @return string The version number
     */
    function version() public pure returns (string memory) {
        return "0.0.1";
    }
}
