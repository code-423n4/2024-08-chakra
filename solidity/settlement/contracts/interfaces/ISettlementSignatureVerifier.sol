// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ISettlementSignatureVerifier {
    /**
     * @notice Add a validator
     * @param validator The validator address
     */
    function add_validator(address validator) external;

    /**
     * @notice Remove a validator
     * @param validator The validator address
     */
    function remove_validator(address validator) external;

    /**
     * @notice Check if the address is a validator
     * @param _validator The validator address
     */
    function is_validator(address _validator) external view returns (bool);

    /**
     * @notice Set the number of validators required to approve a transaction
     * @param _required_validators The number of validators required to approve a transaction
     */
    function set_required_validators_num(uint256 _required_validators) external;

    /**
     * @notice View required validators number.
     */
    function view_required_validators_num() external view returns (uint256);

    /**
     * @notice Verify the signature
     * @param msgHash The hash of the message
     * @param signatures The array of signature
     * @param sign_type The signature type, multisig or bls, the specific value is defined in the implementation
     */
    function verify(
        bytes32 msgHash,
        bytes memory signatures,
        uint8 sign_type
    ) external view returns (bool);
}
