// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {CrossChainMsgStatus, PayloadType} from "contracts/libraries/Message.sol";

interface ISettlementHandler {
    function receive_cross_chain_callback(
        uint256 txid,
        string memory from_chain,
        uint256 from_handler,
        CrossChainMsgStatus status,
        uint8 sign_type, // validators signature type /  multisig or bls sr25519
        bytes calldata signatures
    ) external returns (bool);

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

    // Determine if the handler is in the whitelist
    function is_valid_handler(
        string memory chain_name,
        uint256 handler
    ) external returns (bool);

    function add_handler(string memory chain_name, uint256 handler) external;

    function remove_handler(string memory chain_name, uint256 handler) external;
}
