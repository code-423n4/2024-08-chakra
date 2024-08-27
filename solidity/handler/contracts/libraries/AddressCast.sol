// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library AddressCast {
    error AddressCast_InvalidSizeForAddress();
    error AddressCast_InvalidAddress();

    function to_uint256(
        address _address
    ) internal pure returns (uint256 result) {
        result = uint256(uint160(_address));
    }

    function to_address(
        bytes32 _address
    ) internal pure returns (address result) {
        result = address(uint160(uint256(_address)));
    }

    function to_address(
        uint256 _address
    ) internal pure returns (address result) {
        result = address(uint160(_address));
    }

    function to_bytes32(
        address _address
    ) internal pure returns (bytes32 result) {
        result = bytes32(uint256(uint160(_address)));
    }

    function to_bytes(
        bytes32 _addressBytes32,
        uint256 _size
    ) internal pure returns (bytes memory result) {
        if (_size == 0 || _size > 32)
            revert AddressCast_InvalidSizeForAddress();
        result = new bytes(_size);
        unchecked {
            uint256 offset = 256 - _size * 8;
            assembly {
                mstore(add(result, 32), shl(offset, _addressBytes32))
            }
        }
    }

    function to_bytes32(
        bytes calldata _addressBytes
    ) internal pure returns (bytes32 result) {
        if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();
        result = bytes32(_addressBytes);
        unchecked {
            uint256 offset = 32 - _addressBytes.length;
            result = result >> (offset * 8);
        }
    }
}
