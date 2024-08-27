// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Importing various contracts and libraries
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";

// BaseSettlement is an abstract contract that inherits from OwnableUpgradeable, UUPSUpgradeable, and AccessControlUpgradeable
abstract contract BaseSettlement is
    OwnableUpgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable
{
    // Events for adding and removing managers and validators, and changing required validators
    event ManagerAdded(address indexed owner, address indexed manager);
    event ManagerRemoved(address indexed owner, address indexed manager);
    event ValidatorAdded(address indexed manager, address indexed validator);
    event ValidatorRemoved(address indexed manager, address indexed validator);
    event RequiredValidatorsChanged(
        address indexed manager,
        uint256 indexed old_required_validators,
        uint256 indexed new_required_validators
    );

    // Constant for the manager role
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    // The chain id of the settlement contract
    uint256 public chain_id;
    string public contract_chain_name;

    // The number of required validators
    uint256 public required_validators;

    // The signature verifier contract
    ISettlementSignatureVerifier public signature_verifier;

    // Mapping for nonce manager and validators
    mapping(address => uint256) public nonce_manager;
    mapping(address => bool) public chakra_validators;
    uint256 public validator_count;

    /**
     * @dev Initialize the settlement
     * @param _chain_name The chain name
     * @param _chain_id  The chain id
     * @param _owner The owner address for the contract
     * @param _managers The managers addresses
     * @param _required_validators The required validators number
     * @param _signature_verifier The Verifier contract address
     */
    function _Settlement_init(
        string memory _chain_name,
        uint256 _chain_id,
        address _owner,
        address[] memory _managers,
        uint256 _required_validators,
        address _signature_verifier
    ) public {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);

        for (uint256 i = 0; i < _managers.length; i++) {
            _grantRole(MANAGER_ROLE, _managers[i]);
        }

        chain_id = _chain_id;
        contract_chain_name = _chain_name;
        required_validators = _required_validators;
        signature_verifier = ISettlementSignatureVerifier(_signature_verifier);
    }

    /**
     * @dev Authorize upgrade contract
     * @param newImplementation The new implementation contract address
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Adds a handler to the whitelist
     * @param validator The validator address
     */
    function add_validator(address validator) external onlyRole(MANAGER_ROLE) {
        signature_verifier.add_validator(validator);
        require(
            chakra_validators[validator] == false,
            "Validator already exists"
        );
        chakra_validators[validator] = true;
        validator_count += 1;
        emit ValidatorAdded(msg.sender, validator);
    }

    /**
     * @dev Removes a handler from the whitelist
     * @param validator The validator address
     */
    function remove_validator(
        address validator
    ) external onlyRole(MANAGER_ROLE) {
        signature_verifier.remove_validator(validator);
        require(
            chakra_validators[validator] == true,
            "Validator does not exists"
        );
        chakra_validators[validator] = false;
        validator_count -= 1;
        emit ValidatorRemoved(msg.sender, validator);
    }

    /**
     * @dev Update the required validators num
     * @notice Only manager can dot this
     * @param _required_validators The required validators number
     */
    function set_required_validators_num(
        uint256 _required_validators
    ) external onlyRole(MANAGER_ROLE) {
        uint256 old = required_validators;
        required_validators = _required_validators;
        emit RequiredValidatorsChanged(msg.sender, old, required_validators);
    }

    /**
     * @dev Check if address is a validator
     * @param _validator The address to detect
     */
    function is_validator(address _validator) external view returns (bool) {
        return chakra_validators[_validator];
    }

    /**
     * @dev Get now reuiqred validators number
     */
    function view_required_validators_num() external view returns (uint256) {
        return required_validators;
    }

    /**
     * @dev Grant a manager role for address
     * @notice Only owner can do this
     * @param _manager The manager address
     */
    function add_manager(address _manager) external onlyOwner {
        grantRole(MANAGER_ROLE, _manager);
        emit ManagerAdded(msg.sender, _manager);
    }

    /**
     * @dev Revoke a manager role for address
     * @notice Only owner can do this
     * @param _manager The manager address
     */
    function remove_manager(address _manager) external onlyOwner {
        revokeRole(MANAGER_ROLE, _manager);
        emit ManagerRemoved(msg.sender, _manager);
    }

    /**
     * @dev Check if address is a manager
     * @param _manager The manager address
     */
    function is_manager(address _manager) external view returns (bool) {
        return hasRole(MANAGER_ROLE, _manager);
    }

    /**
     * @dev Get nonce of an account
     * @param account The account address
     */
    function view_nonce(address account) external view returns (uint256) {
        return nonce_manager[account];
    }

    /**
     * @dev Get the contract version
     */
    function version() public pure virtual returns (string memory) {
        return "0.1.0";
    }
}
