// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20CodecV1} from "contracts/tests/IERC20CodecV1.t.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "contracts/tests/ERC20Payload.t.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract ERC20CodecV1 is IERC20CodecV1, OwnableUpgradeable, UUPSUpgradeable {
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Encode transfer payload
     * @param _payload ERC20TransferPayload
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
     * @dev Decode method id
     * @param _payload bytes
     */
    function decode_method(
        bytes calldata _payload
    ) external pure returns (ERC20Method method) {
        return ERC20Method(uint8(_payload[0]));
    }

    /**
     * @dev Decode transfer payload
     * @param _payload bytes
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
