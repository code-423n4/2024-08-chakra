// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Message, PayloadType} from "contracts/libraries/Message.sol";

library MessageV1Codec {
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

    /**
     * @notice This method uses abi.encodedPacket to encode messages
     * @param _msg Encoded message
     */
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

    /**
     * @notice This method use abi.encodedPacked to ecnode message, but only header (version + id + payload_type).
     * @param _msg Encoded message
     */
    function encode_message_header(
        Message memory _msg
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(MESSAGE_VERSION, _msg.id, _msg.payload_type);
    }

    /**
     * @notice This method use abi.encodedPacked to ecnode message, but only payload
     * @param _msg Encoded message
     */
    function encode_payload(
        Message memory _msg
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(_msg.payload);
    }

    /**
     * @notice This method decode the message and return all header value.
     * @param _msg Decoded message
     */
    function header(
        bytes calldata _msg
    ) internal pure returns (bytes calldata) {
        return _msg[0:PAYLOAD_OFFSET];
    }

    /**
     * @notice This method decode the message and return version value.
     * @param _msg Decoded message
     */
    function version(bytes calldata _msg) internal pure returns (uint8) {
        return uint8(bytes1(_msg[PACKET_VERSION_OFFSET:ID_OFFSET]));
    }

    /**
     * @notice This method decode the message and return id value.
     * @param _msg Decoded message
     */
    function id(bytes calldata _msg) internal pure returns (uint64) {
        return uint64(bytes8(_msg[ID_OFFSET:PAYLOAD_TYPE_OFFSET]));
    }

    /**
     * @notice This method decode the message and return payload_type value.
     * @param _msg Decoded message
     */
    function payload_type(
        bytes calldata _msg
    ) internal pure returns (PayloadType) {
        uint8 typ = uint8(bytes1(_msg[PAYLOAD_TYPE_OFFSET:PAYLOAD_OFFSET]));
        return PayloadType(typ);
    }

    /**
     * @notice This method decode the message and return raw payload.
     * @param _msg Decoded message
     */
    function payload(
        bytes calldata _msg
    ) internal pure returns (bytes calldata) {
        return bytes(_msg[PAYLOAD_OFFSET:]);
    }

    /**
     * @notice This method calculate whole hash of message using keccak256.
     * @param _msg Decoded message
     */
    function payload_hash(bytes calldata _msg) internal pure returns (bytes32) {
        return keccak256(payload(_msg));
    }
}
