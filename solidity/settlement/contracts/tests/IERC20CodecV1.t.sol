// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "contracts/tests/ERC20Payload.t.sol";

interface IERC20CodecV1 {
    // transfer
    function encode_transfer(
        ERC20TransferPayload memory payload
    ) external pure returns (bytes memory);

    // Decode method id
    function decode_method(
        bytes calldata payload
    ) external pure returns (ERC20Method);

    // Decode transfer
    function deocde_transfer(
        bytes calldata payload
    ) external pure returns (ERC20TransferPayload memory);
}
