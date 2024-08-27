// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ISettlementSignatureVerifier {
    /**
     * @notice Verify the signature
     * @param msgHash The hash of the message
     * @param signatures The signature
     * @param signers The signer
     * @param sign_type The signature type, multisig or bls, the specific value is defined in the implementation
     */
    function verify(
        bytes32 msgHash,
        bytes calldata signatures,
        address[] calldata signers,
        uint8 sign_type
    ) external pure returns (bool);
}
