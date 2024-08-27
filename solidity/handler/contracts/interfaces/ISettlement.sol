// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";
import {PayloadType} from "contracts/libraries/Message.sol";

interface ISettlement {
    function send_cross_chain_msg(
        string memory to_chain,
        address from_address,
        uint256 to_handler,
        PayloadType payload_type,
        bytes calldata payload
    ) external;

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
