// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "contracts/libraries/ERC20Payload.sol";

/**
 * @title IERC20CodecV1
 * @dev Interface for encoding and decoding ERC20 token operations
 */
interface IERC20CodecV1 {
    /**
     * @dev Encodes an ERC20 transfer payload
     * @param payload ERC20TransferPayload struct containing transfer details
     * @return Encoded bytes of the transfer payload
     */
    function encode_transfer(
        ERC20TransferPayload memory payload
    ) external pure returns (bytes memory);

    /**
     * @dev Decodes the method from a payload
     * @param payload Encoded payload
     * @return The decoded ERC20Method
     */
    function decode_method(
        bytes calldata payload
    ) external pure returns (ERC20Method);

    /**
     * @dev Decodes a transfer payload
     * @param payload Encoded transfer payload
     * @return Decoded ERC20TransferPayload struct
     */
    function deocde_transfer(
        bytes calldata payload
    ) external pure returns (ERC20TransferPayload memory);
}
