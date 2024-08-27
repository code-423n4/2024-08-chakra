// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import {BaseSettlementTest} from "contracts/tests/BaseSettlement.t.sol";
import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";
import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";
import {CrossChainMsgStatus, PayloadType} from "contracts/libraries/Message.sol";

contract SettlementTest is BaseSettlementTest {
    mapping(uint256 => CreatedCrossChainTx) public create_cross_txs;
    mapping(uint256 => ReceivedCrossChainTx) public receive_cross_txs;

    struct CreatedCrossChainTx {
        uint256 txid;
        string from_chain;
        string to_chain;
        address from_address;
        address from_handler;
        uint256 to_handler;
        bytes payload;
        CrossChainMsgStatus status;
    }

    struct ReceivedCrossChainTx {
        uint256 txid;
        string from_chain;
        string to_chain;
        uint256 from_address;
        uint256 from_handler;
        address to_handler;
        bytes payload;
        CrossChainMsgStatus status;
    }

    // Events
    event CrossChainMsg(
        uint256 indexed txid,
        address indexed from_address,
        string from_chain,
        string to_chain,
        address from_handler,
        uint256 to_handler,
        PayloadType payload_type,
        bytes payload
    );

    // cross chain handle result emit by receive side
    event CrossChainHandleResult(
        uint256 indexed txid,
        CrossChainMsgStatus status,
        string from_chain,
        string to_chain,
        address from_handler,
        uint256 to_handler
    );

    // Cross Chain result emit by sender side
    event CrossChainResult(
        uint256 indexed txid,
        string from_chain,
        string to_chain,
        address from_address,
        address from_handler,
        uint256 to_handler,
        CrossChainMsgStatus status
    );

    function initialize(
        string memory _chain_name,
        uint256 _chain_id,
        address _owner,
        ISettlementSignatureVerifier _verify_contract
    ) public initializer {
        _Settlement_init(_chain_name, _chain_id, _owner, _verify_contract);
    }

    function send_cross_chain_msg(
        string memory to_chain,
        address from_address,
        uint256 to_handler,
        PayloadType payload_type,
        bytes calldata payload
    ) external virtual {
        nonce_manager[from_address] += 1;
        string memory from_chain = contract_chain_name;

        address from_handler = msg.sender;

        uint256 txid = uint256(
            keccak256(
                abi.encodePacked(
                    from_chain,
                    to_chain,
                    from_address,
                    from_handler,
                    to_handler,
                    nonce_manager[from_address],
                    payload
                )
            )
        );

        create_cross_txs[txid] = CreatedCrossChainTx(
            txid,
            from_chain,
            to_chain,
            from_address,
            address(this),
            to_handler,
            payload,
            CrossChainMsgStatus.Pending
        );

        emit CrossChainMsg(
            txid,
            from_address,
            from_chain,
            to_chain,
            from_handler,
            to_handler,
            payload_type,
            payload
        );
    }

    function receive_cross_chain_msg(
        uint256 txid,
        string memory from_chain,
        uint256 from_address,
        uint256 from_handler,
        ISettlementHandler to_handler,
        PayloadType payload_type,
        bytes calldata payload,
        uint8 sign_type,
        bytes calldata signatures
    ) external {
        verifySignature(
            txid,
            from_chain,
            from_address,
            from_handler,
            to_handler,
            payload,
            sign_type,
            signatures
        );
        processCrossChainMsg(
            txid,
            from_chain,
            from_address,
            from_handler,
            to_handler,
            payload_type,
            payload,
            sign_type,
            signatures
        );
    }

    function verifySignature(
        uint256 txid,
        string memory from_chain,
        uint256 from_address,
        uint256 from_handler,
        ISettlementHandler to_handler,
        bytes memory payload,
        uint8 sign_type,
        bytes memory signatures
    ) internal view {
        bytes32 message_hash = MessageHashUtils.toEthSignedMessageHash(
            keccak256(
                abi.encodePacked(
                    txid,
                    from_chain,
                    from_address,
                    from_handler,
                    to_handler,
                    payload
                )
            )
        );

        // FIXME: replace with the right signers
        address[] memory signers = new address[](0);
        require(
            signature_verifier.verify(
                message_hash,
                signatures,
                signers,
                sign_type
            ),
            "Invalid signature"
        );
    }

    function processCrossChainMsg(
        uint256 txid,
        string memory from_chain,
        uint256 from_address,
        uint256 from_handler,
        ISettlementHandler to_handler,
        PayloadType payload_type,
        bytes memory payload,
        uint8 sign_type,
        bytes memory signatures
    ) internal {
        require(
            receive_cross_txs[txid].status == CrossChainMsgStatus.Pending,
            "Invalid transaction status"
        );

        receive_cross_txs[txid] = ReceivedCrossChainTx(
            txid,
            from_chain,
            contract_chain_name,
            from_address,
            from_handler,
            address(this),
            payload,
            CrossChainMsgStatus.Pending
        );

        bool result = to_handler.receive_cross_chain_msg(
            txid,
            from_chain,
            from_address,
            from_handler,
            payload_type,
            payload,
            sign_type,
            signatures
        );

        if (result == true) {
            receive_cross_txs[txid].status = CrossChainMsgStatus.Success;
            emit CrossChainHandleResult(
                txid,
                CrossChainMsgStatus.Success,
                contract_chain_name,
                from_chain,
                address(this),
                from_handler
            );
        } else {
            receive_cross_txs[txid].status = CrossChainMsgStatus.Failed;
            emit CrossChainHandleResult(
                txid,
                CrossChainMsgStatus.Failed,
                contract_chain_name,
                from_chain,
                address(this),
                from_handler
            );
        }
    }

    function receive_cross_chain_callback(
        uint256 txid,
        string memory from_chain,
        uint256 from_handler,
        address to_handler,
        CrossChainMsgStatus status,
        uint8 sign_type, // validators signature type /  multisig or bls sr25519
        bytes calldata signatures
    ) external {
        CreatedCrossChainTx storage ccc_tx = create_cross_txs[txid];
        {
            // verify signature
            bytes32 message_hash = MessageHashUtils.toEthSignedMessageHash(
                keccak256(
                    abi.encodePacked(txid, from_handler, to_handler, status)
                )
            );

            // FIXME: replace with the right signers
            address[] memory signers = new address[](0);

            require(
                signature_verifier.verify(
                    message_hash,
                    signatures,
                    signers,
                    sign_type
                ),
                "Invalid signature"
            );

            // Update txid result
            require(
                ccc_tx.status == CrossChainMsgStatus.Pending,
                "Invalid transaction status"
            );
        }

        {
            bool success = ISettlementHandler(to_handler)
                .receive_cross_chain_callback(
                    txid,
                    from_chain,
                    from_handler,
                    status,
                    sign_type,
                    signatures
                );
            if (success == true) {
                ccc_tx.status = status;
            } else {
                ccc_tx.status = CrossChainMsgStatus.Failed;
            }
        }

        emit CrossChainResult(
            txid,
            ccc_tx.from_chain,
            ccc_tx.to_chain,
            ccc_tx.from_address,
            ccc_tx.from_handler,
            ccc_tx.to_handler,
            ccc_tx.status
        );
    }
}
