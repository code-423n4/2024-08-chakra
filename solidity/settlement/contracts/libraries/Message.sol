// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// The Payload type defines the type of payload in the Message
enum PayloadType {
    // Raw payload
    Raw,
    // BTC deposit payload
    BTCDeposit,
    // BTC withdrawal payload
    BTCWithdraw,
    // BTC Stake
    BTCStake,
    // BTC unstake
    BTCUnStake,
    // ERC20 payload
    ERC20,
    // ERC721 payload
    ERC721
}

// The Message struct defines the message of corss chain
struct Message {
    // The id of the message
    uint256 id;
    // The type of the payload
    PayloadType payload_type;
    // The payload of the message
    bytes payload;
}

// The CrossChainMsgStatus defines the status of cross chain message
enum CrossChainMsgStatus {
    Unknow,
    Pending,
    Success,
    Failed
}
