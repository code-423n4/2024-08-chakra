// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Importing various contracts and libraries
import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @dev SettlementSignatureVerifier contract that inherits from OwnableUpgradeable, UUPSUpgradeable, AccessControlUpgradeable, and ISettlementSignatureVerifier
 * @notice This contract verifies the signatures of settlements
 */
contract SettlementSignatureVerifier is
    OwnableUpgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable,
    ISettlementSignatureVerifier
{
    // Using ECDSA library for bytes32
    using ECDSA for bytes32;

    // Events for adding and removing managers and validators, and changing required validators
    event ValidatorAdded(address indexed manager, address indexed validator);
    event ValidatorRemoved(address indexed manager, address indexed validator);
    event ManagerAdded(address indexed owner, address indexed manager);
    event ManagerRemoved(address indexed owner, address indexed manager);
    event RequiredValidatorsChanged(
        address indexed manager,
        uint256 indexed old_required_validators,
        uint256 indexed new_required_validators
    );

    // Constant for the manager role
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    // The number of required validators
    uint256 public required_validators;

    // Mapping for validators
    mapping(address => bool) public validators;
    uint256 public validator_count;

    // Modifier to check if the caller is a validator
    modifier onlyValidator() {
        require(validators[msg.sender] == true, "Not validator");
        _;
    }

    /**
     * @dev Function to initialize the verifier
     * @notice Initializes the verifier with owner and required validators
     * @param _owner The owner of the contract
     * @param _required_validators The number of required validators
     */
    function initialize(
        address _owner,
        uint256 _required_validators
    ) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);

        required_validators = _required_validators;
    }

    /**
     * @dev Function to authorize upgrade
     * @notice Authorizes an upgrade of the contract
     * @param newImplementation The new implementation of the contract
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Function to add manager
     * @notice Adds a manager to the contract
     * @param _manager The manager to add
     */
    function add_manager(address _manager) external onlyOwner {
        grantRole(MANAGER_ROLE, _manager);
        emit ManagerAdded(msg.sender, _manager);
    }

    /**
     * @dev Function to remove manager
     * @notice Removes a manager from the contract
     * @param _manager The manager to remove
     */
    function remove_manager(address _manager) external onlyOwner {
        revokeRole(MANAGER_ROLE, _manager);
        emit ManagerRemoved(msg.sender, _manager);
    }

    /**
     * @dev Function to check if an address is a manager
     * @notice Checks if an address is a manager
     * @param _manager The address to check
     * @return A boolean indicating if the address is a manager
     */
    function is_manager(address _manager) external view returns (bool) {
        return hasRole(MANAGER_ROLE, _manager);
    }

    /**
     * @dev Function to add validator
     * @notice Adds a validator to the contract
     * @param validator The validator to add
     */
    function add_validator(address validator) external onlyRole(MANAGER_ROLE) {
        require(validators[validator] == false, "Validator already exists");
        validators[validator] = true;
        validator_count += 1;
        emit ValidatorAdded(msg.sender, validator);
    }

    /**
     * @dev Function to remove validator
     * @notice Removes a validator from the contract
     * @param validator The validator to remove
     */
    function remove_validator(
        address validator
    ) external onlyRole(MANAGER_ROLE) {
        require(validators[validator] == true, "Validator does not exists");
        validators[validator] = false;
        validator_count -= 1;
        emit ValidatorRemoved(msg.sender, validator);
    }

    /**
     * @dev Function to set required validators number
     * @notice Sets the number of required validators
     * @param _required_validators The number of required validators
     */
    function set_required_validators_num(
        uint256 _required_validators
    ) external virtual onlyRole(MANAGER_ROLE) {
        uint256 old = required_validators;
        required_validators = _required_validators;
        emit RequiredValidatorsChanged(msg.sender, old, required_validators);
    }

    /**
     * @dev Function to check if an address is a validator
     * @notice Checks if an address is a validator
     * @param _validator The address to check
     * @return A boolean indicating if the address is a validator
     */
    function is_validator(address _validator) external view returns (bool) {
        return validators[_validator];
    }

    /**
     * @dev Function to view required validators number
     * @notice Views the number of required validators
     * @return The number of required validators
     */
    function view_required_validators_num() external view returns (uint256) {
        return required_validators;
    }

    /**
     * @dev Function to verify a message
     * @notice Verifies a message with a given hash, signatures, and sign type
     * @param msgHash The hash of the message
     * @param signatures The signatures of the message
     * @param sign_type The type of the signature
     * @return A boolean indicating if the message is verified
     */
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

    /**
     * @dev Function to verify an ECDSA signature
     * @notice Verifies an ECDSA signature with a given message hash and signatures
     * @param msgHash The hash of the message
     * @param signatures The signatures of the message
     * @return A boolean indicating if the signature is verified
     */
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
