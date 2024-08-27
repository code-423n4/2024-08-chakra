// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Message, PayloadType} from "contracts/libraries/Message.sol";
import {AddressCast} from "contracts/libraries/AddressCast.sol";

library MessageV1Codec {
    using AddressCast for address;
    using AddressCast for bytes32;

    uint8 internal constant MESSAGE_VERSION = 1;

    // header (version + id +  type)
    // version
    uint256 internal constant PACKET_VERSION_OFFSET = 0;
    // id
    uint256 internal constant ID_OFFSET = 1;
    // type
    uint256 internal constant PAYLOAD_TYPE_OFFSET = 33;
    // payload
    uint256 internal constant PAYLOAD_OFFSET = 34;

    function encode(
        Message memory _msg
    ) internal pure returns (bytes memory encodedMessage) {
        encodedMessage = abi.encodePacked(
            MESSAGE_VERSION,
            _msg.id,
            _msg.payload_type,
            _msg.payload
        );
    }

    function encode_message_header(
        Message memory _msg
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(MESSAGE_VERSION, _msg.id, _msg.payload_type);
    }

    function encode_payload(
        Message memory _msg
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(_msg.payload);
    }

    function header(
        bytes calldata _msg
    ) internal pure returns (bytes calldata) {
        return _msg[0:PAYLOAD_OFFSET];
    }

    function version(bytes calldata _msg) internal pure returns (uint8) {
        return uint8(bytes1(_msg[PACKET_VERSION_OFFSET:ID_OFFSET]));
    }

    function id(bytes calldata _msg) internal pure returns (uint64) {
        return uint64(bytes8(_msg[ID_OFFSET:PAYLOAD_TYPE_OFFSET]));
    }

    function payload_type(
        bytes calldata _msg
    ) internal pure returns (PayloadType) {
        uint8 typ = uint8(bytes1(_msg[PAYLOAD_TYPE_OFFSET:PAYLOAD_OFFSET]));
        return PayloadType(typ);
    }

    function payload(
        bytes calldata _msg
    ) internal pure returns (bytes calldata) {
        return bytes(_msg[PAYLOAD_OFFSET:]);
    }

    function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {
        return keccak256(payload(_msg));
    }
}
