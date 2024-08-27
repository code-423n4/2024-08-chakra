// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";
import {PayloadType} from "contracts/libraries/Message.sol";

interface ISettlement {
    /**
     * @notice Sends a cross-chain message to the specified chain.
     * @param to_chain The name or identifier of the destination chain.
     * @param from_address The address of the sender on the current chain.
     * @param to_handler The ID or address of the handler on the destination chain.
     * @param payload_type The type of data payload.
     * @param payload The data payload to be sent across the chain.
     */
    function send_cross_chain_msg(
        string memory to_chain,
        address from_address,
        uint256 to_handler,
        PayloadType payload_type,
        bytes calldata payload
    ) external;

    /**
     * @notice Receives a cross-chain message from the specified chain.
     * @param txid The unique identifier of the cross-chain transaction.
     * @param from_chain The name or identifier of the chain the message is coming from.
     * @param from_address The address of the sender on the source chain.
     * @param from_handler The ID or address of the handler on the source chain.
     * @param to_handler The recipient handler on the current chain.
     * @param payload_type The type of data payload.
     * @param payload The data payload received from the cross-chain transaction.
     * @param sign_type The type of signature used to verify the message, such as a multisig or BLS (Boneh-Lynn-Shacham) signature.
     * @param signatures The actual signatures used to verify the message.
     */
    function receive_cross_chain_msg(
        uint256 txid,
        string memory from_chain,
        address from_address,
        uint256 from_handler,
        ISettlementHandler to_handler,
        PayloadType payload_type,
        bytes calldata payload,
        uint8 sign_type, // validators signature type /  multisig or bls sr25519
        bytes calldata signatures
    ) external;
}
