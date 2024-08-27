// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";

// Interface for a settlement handler, responsible for processing cross-chain messages
interface ISettlementHandler {
    // Callback function invoked when a cross-chain message is received
    //
    // @param txid Unique identifier of the cross-chain transaction
    // @param from_chain Origin chain of the message
    // @param from_handler Handler address on the origin chain
    // @param status Status of the cross-chain message (success, failure, etc.)
    // @param sign_type Type of signature used by validators (e.g., multisig, BLS sr25519)
    // @param signatures Validators' signatures for the message
    function receive_cross_chain_callback(
        uint256 txid,
        string memory from_chain,
        uint256 from_handler,
        CrossChainMsgStatus status,
        uint8 sign_type,
        bytes calldata signatures
    ) external returns (bool);

    // Function to receive a cross-chain message and process its payload
    //
    // @param txid Unique identifier of the cross-chain transaction
    // @param from_chain Origin chain of the message
    // @param from_address Sender address on the origin chain
    // @param from_handler Handler address on the origin chain
    // @param payload_type Type of the message payload
    // @param payload The actual message payload
    // @param sign_type Type of signature used by validators (e.g., multisig, BLS sr25519)
    // @param signatures Validators' signatures for the message
    function receive_cross_chain_msg(
        uint256 txid,
        string memory from_chain,
        uint256 from_address,
        uint256 from_handler,
        PayloadType payload_type,
        bytes calldata payload,
        uint8 sign_type,
        bytes calldata signatures
    ) external returns (bool);
}
