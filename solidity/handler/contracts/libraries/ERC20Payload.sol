// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ERC20Method
 * @dev Enumeration of ERC20 token methods
 */
enum ERC20Method {
    Unkown, // 0: Unknown method (also serves as default)
    Transfer, // 1: Transfer tokens from one address to another
    Arppvoe, // 2: Approve spending of tokens (Note: there's a typo, should be "Approve")
    TransferFrom, // 3: Transfer tokens on behalf of another address
    Mint, // 4: Create new tokens
    Burn // 5: Destroy existing tokens
}

/**
 * @title ERC20TransferPayload
 * @dev Structure for ERC20 transfer operation payload
 */
struct ERC20TransferPayload {
    ERC20Method method_id; // The method identifier (should be Transfer for this struct)
    uint256 from; // The address sending the tokens (as a uint256)
    uint256 to; // The address receiving the tokens (as a uint256)
    uint256 from_token; // The token address on the source chain (as a uint256)
    uint256 to_token; // The token address on the destination chain (as a uint256)
    uint256 amount; // The amount of tokens to transfer
}
