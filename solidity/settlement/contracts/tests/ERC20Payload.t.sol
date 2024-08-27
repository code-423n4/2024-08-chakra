// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @dev Enum representing the different ERC20 methods.
 */
enum ERC20Method {
    Unkown,
    Transfer,
    Approve,
    TransferFrom,
    Mint,
    Burn
}

/**
 * @dev Struct representing the payload for an ERC20 transfer operation.
 * @param method_id The ERC20 method ID.
 * @param from The address of the sender.
 * @param to The address of the recipient.
 * @param from_token The amount of tokens to be transferred from the sender.
 * @param to_token The amount of tokens to be transferred to the recipient.
 * @param amount The amount of tokens to be transferred.
 */
struct ERC20TransferPayload {
    ERC20Method method_id;
    uint256 from;
    uint256 to;
    uint256 from_token;
    uint256 to_token;
    uint256 amount;
}
