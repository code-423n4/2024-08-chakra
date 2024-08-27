// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20CodecV1} from "contracts/interfaces/IERC20CodecV1.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "contracts/libraries/ERC20Payload.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title ERC20CodecV1
 * @dev Implements encoding and decoding functions for ERC20 token operations
 */
contract ERC20CodecV1 is IERC20CodecV1, OwnableUpgradeable, UUPSUpgradeable {
    /**
     * @dev Initializes the contract
     * @param _owner Address of the contract owner
     */
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
    }

    /**
     * @dev Function to authorize an upgrade
     * @param newImplementation Address of the new implementation
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Encodes an ERC20 transfer payload
     * @param _payload ERC20TransferPayload struct containing transfer details
     * @return encodedPaylaod Encoded bytes of the transfer payload
     */
    function encode_transfer(
        ERC20TransferPayload memory _payload
    ) external pure returns (bytes memory encodedPaylaod) {
        encodedPaylaod = abi.encodePacked(
            _payload.method_id,
            _payload.from,
            _payload.to,
            _payload.from_token,
            _payload.to_token,
            _payload.amount
        );
    }

    /**
     * @dev Decodes the method from a payload
     * @param _payload Encoded payload
     * @return method The decoded ERC20Method
     */
    function decode_method(
        bytes calldata _payload
    ) external pure returns (ERC20Method method) {
        return ERC20Method(uint8(_payload[0]));
    }

    /**
     * @dev Decodes a transfer payload
     * @param _payload Encoded transfer payload
     * @return transferPayload Decoded ERC20TransferPayload struct
     */
    function deocde_transfer(
        bytes calldata _payload
    ) external pure returns (ERC20TransferPayload memory transferPayload) {
        transferPayload.method_id = ERC20Method(uint8(_payload[0]));
        transferPayload.from = abi.decode(_payload[1:33], (uint256));
        transferPayload.to = abi.decode(_payload[33:65], (uint256));
        transferPayload.from_token = abi.decode(_payload[65:97], (uint256));
        transferPayload.to_token = abi.decode(_payload[97:129], (uint256));
        transferPayload.amount = abi.decode(_payload[129:161], (uint256));
    }
}
