// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library AddressCast {
    error AddressCast_InvalidSizeForAddress();
    error AddressCast_InvalidAddress();

    /**
     * @notice Casting the address to uint256
     * @param _address The address value
     */
    function to_uint256(
        address _address
    ) internal pure returns (uint256 result) {
        result = uint256(uint160(_address));
    }

    /**
     * @notice Casting the bytes32 representation of the address to address
     * @param _address The address value
     */
    function to_address(
        bytes32 _address
    ) internal pure returns (address result) {
        result = address(uint160(uint256(_address)));
    }

    /**
     * @notice Casting the uint256 representation of the address to address
     * @param _address The address value
     */
    function to_address(
        uint256 _address
    ) internal pure returns (address result) {
        result = address(uint160(_address));
    }

    /**
     * @notice Casting the address to bytes32 representation
     * @param _address The address value
     */
    function to_bytes32(
        address _address
    ) internal pure returns (bytes32 result) {
        result = bytes32(uint256(uint160(_address)));
    }

    /**
     * @dev Converts a bytes32 value to a bytes memory array of a specified size.
     * @param _addressBytes32 The bytes32 value to be converted.
     * @param _size The desired size of the resulting bytes memory array.
     * @return result The bytes memory array of the specified size.
     * @custom:error AddressCast_InvalidSizeForAddress Thrown when the specified size is 0 or greater than 32.
     */
    function to_bytes(
        bytes32 _addressBytes32,
        uint256 _size
    ) internal pure returns (bytes memory result) {
        // Check if the specified size is valid (between 1 and 32 bytes)
        if (_size == 0 || _size > 32)
            revert AddressCast_InvalidSizeForAddress();

        // Create a new bytes memory array of the specified size
        result = new bytes(_size);

        // Perform the conversion using assembly
        unchecked {
            // Calculate the offset based on the desired size
            uint256 offset = 256 - _size * 8;
            assembly {
                // Store the left-shifted bytes32 value in the result array
                mstore(add(result, 32), shl(offset, _addressBytes32))
            }
        }
    }

    /**
     * @dev Converts a bytes calldata array to a bytes32 value.
     * @param _addressBytes The bytes calldata array to be converted.
     * @return result The bytes32 value.
     * @custom:error AddressCast_InvalidAddress Thrown when the input bytes calldata array is longer than 32 bytes.
     */
    function to_bytes32(
        bytes calldata _addressBytes
    ) internal pure returns (bytes32 result) {
        // Check if the input bytes calldata array is longer than 32 bytes
        if (_addressBytes.length > 32) revert AddressCast_InvalidAddress();

        // Convert the bytes calldata array to a bytes32 value
        result = bytes32(_addressBytes);

        // Shift the bytes32 value to the right by the appropriate number of bytes
        // based on the length of the input bytes calldata array
        unchecked {
            uint256 offset = 32 - _addressBytes.length;
            result = result >> (offset * 8);
        }
    }
}
