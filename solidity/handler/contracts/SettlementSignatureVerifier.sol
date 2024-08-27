// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract SettlementSignatureVerifier is
    OwnableUpgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable
{
    using ECDSA for bytes32;

    event ValidatorAdded(address indexed manager, address indexed validator);

    event ValidatorRemoved(address indexed manager, address indexed validator);

    event ManagerAdded(address indexed owner, address indexed manager);

    event ManagerRemoved(address indexed owner, address indexed manager);

    event RequiredValidatorsChanged(
        address indexed manager,
        uint256 indexed old_required_validators,
        uint256 indexed new_required_validators
    );

    event Test(address validator);
    /**
     * @notice The MANAGER_ROLE indicats that only this only can be call add_validator and remove_validator.
     */
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    uint256 public required_validators;

    mapping(address => bool) public validators;
    uint256 public validator_count;

    modifier onlyValidator() {
        require(validators[msg.sender] == true, "Not validator");
        _;
    }

    function initialize(
        address _owner,
        uint256 _required_validators
    ) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);

        required_validators = _required_validators;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function add_manager(address _manager) external onlyOwner {
        grantRole(MANAGER_ROLE, _manager);
        emit ManagerAdded(msg.sender, _manager);
    }

    function remove_manager(address _manager) external onlyOwner {
        revokeRole(MANAGER_ROLE, _manager);
        emit ManagerRemoved(msg.sender, _manager);
    }

    function is_manager(address _manager) external view returns (bool) {
        return hasRole(MANAGER_ROLE, _manager);
    }

    function add_validator(address validator) external onlyRole(MANAGER_ROLE) {
        require(validators[validator] == false, "Validator already exists");
        validators[validator] = true;
        validator_count += 1;
        emit ValidatorAdded(msg.sender, validator);
    }

    function remove_validator(
        address validator
    ) external onlyRole(MANAGER_ROLE) {
        require(validators[validator] == true, "Validator does not exists");
        validators[validator] = false;
        validator_count -= 1;
        emit ValidatorRemoved(msg.sender, validator);
    }

    function set_required_validators_num(
        uint256 _required_validators
    ) external virtual onlyRole(MANAGER_ROLE) {
        uint256 old = required_validators;
        required_validators = _required_validators;
        emit RequiredValidatorsChanged(msg.sender, old, required_validators);
    }

    function is_validator(address _validator) external view returns (bool) {
        return validators[_validator];
    }

    function view_required_validators_num() external view returns (uint256) {
        return required_validators;
    }

    function verify(
        bytes32 msgHash,
        bytes calldata signatures,
        uint8 sign_type
    ) external view returns (bool) {
        if (sign_type == 0) {
            return verifyECDSA(msgHash, signatures);
        } else {
            return false;
        }
    }

    function verifyECDSA(
        bytes32 msgHash,
        bytes calldata signatures
    ) internal view returns (bool) {
        require(
            signatures.length % 65 == 0,
            "Signature length must be a multiple of 65"
        );

        uint256 len = signatures.length;
        uint256 m = 0;
        for (uint256 i = 0; i < len; i += 65) {
            bytes memory sig = signatures[i:i + 65];
            if (
                validators[msgHash.recover(sig)] && ++m >= required_validators
            ) {
                return true;
            }
        }

        return false;
    }
}
