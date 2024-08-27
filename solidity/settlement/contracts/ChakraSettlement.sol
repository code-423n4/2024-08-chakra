// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BaseSettlement} from "contracts/BaseSettlement.sol";
import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";
import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";
import {PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";

// ChakraSettlement contract that inherits from BaseSettlement
contract ChakraSettlement is BaseSettlement {
    mapping(uint256 => CreatedCrossChainTx) public create_cross_txs;
    mapping(uint256 => ReceivedCrossChainTx) public receive_cross_txs;

    /**
     * @dev Struct for created cross-chain transactions
     */
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

    /**
     * @dev Struct for received cross-chain transactions
     */
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

    // Events for cross-chain messages
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
        uint256 to_handler,
        PayloadType payload_type
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

    /**
     * @dev Function to initialize the settlement
     * @param _chain_name The name of the chain
     * @param _chain_id The id of the chain
     * @param _owner The owner of the contract
     * @param _managers The managers of the contract
     * @param _required_validators The number of required validators
     * @param _verify_contract The verify contract
     */
    function initialize(
        string memory _chain_name,
        uint256 _chain_id,
        address _owner,
        address[] memory _managers,
        uint256 _required_validators,
        address _verify_contract
    ) public initializer {
        _Settlement_init(
            _chain_name,
            _chain_id,
            _owner,
            _managers,
            _required_validators,
            _verify_contract
        );
    }

    /**
     * @dev Function to send cross-chain message
     * @param to_chain The chain to send the message to
     * @param from_address The address sending the message
     * @param to_handler The handler to handle the message
     * @param payload_type The type of the payload
     * @param payload The payload of the message
     */
    function send_cross_chain_msg(
        string memory to_chain,
        address from_address,
        uint256 to_handler,
        PayloadType payload_type,
        bytes calldata payload
    ) external {
        nonce_manager[from_address] += 1;

        address from_handler = msg.sender;

        uint256 txid = uint256(
            keccak256(
                abi.encodePacked(
                    contract_chain_name, // from chain
                    to_chain,
                    from_address, // msg.sender address
                    from_handler, // settlement handler address
                    to_handler,
                    nonce_manager[from_address]
                )
            )
        );

        create_cross_txs[txid] = CreatedCrossChainTx(
            txid,
            contract_chain_name,
            to_chain,
            from_address,
            from_handler,
            to_handler,
            payload,
            CrossChainMsgStatus.Pending
        );

        emit CrossChainMsg(
            txid,
            from_address,
            contract_chain_name,
            to_chain,
            from_handler,
            to_handler,
            payload_type,
            payload
        );
    }

    /**
     * @dev Function to receive cross-chain message
     * @param txid The transaction id
     * @param from_chain The chain the message is from
     * @param from_address The address the message is from
     * @param from_handler The handler the message is from
     * @param to_handler The handler to handle the message
     * @param payload_type The type of the payload
     * @param payload The payload of the message
     * @param sign_type The type of the signature
     * @param signatures The signatures of the message
     */
    function receive_cross_chain_msg(
        uint256 txid,
        string memory from_chain,
        uint256 from_address,
        uint256 from_handler,
        address to_handler,
        PayloadType payload_type,
        bytes calldata payload,
        uint8 sign_type, // validators signature type /  multisig or bls sr25519
        bytes calldata signatures // signature array
    ) external {
        {
            // verify signature
            bytes32 message_hash = keccak256(
                abi.encodePacked(
                    txid,
                    from_chain,
                    from_address,
                    from_handler,
                    to_handler,
                    keccak256(payload)
                )
            );

            require(
                signature_verifier.verify(message_hash, signatures, sign_type),
                "Invalid signature"
            );

            require(
                receive_cross_txs[txid].status == CrossChainMsgStatus.Unknow,
                "Invalid transaction status"
            );
        }

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

        bool result = ISettlementHandler(to_handler).receive_cross_chain_msg(
            txid,
            from_chain,
            from_address,
            from_handler,
            payload_type,
            payload,
            sign_type,
            signatures
        );

        CrossChainMsgStatus status = CrossChainMsgStatus.Failed;
        if (result == true) {
            status = CrossChainMsgStatus.Success;
            receive_cross_txs[txid].status = CrossChainMsgStatus.Success;
        } else {
            receive_cross_txs[txid].status = CrossChainMsgStatus.Failed;
        }

        emit CrossChainHandleResult(
            txid,
            status,
            contract_chain_name,
            from_chain,
            address(to_handler),
            from_handler,
            payload_type
        );
    }

    /**
     * @dev Function to receive cross-chain callback
     * @param txid The transaction id
     * @param from_chain The chain the callback is from
     * @param from_handler The handler the callback is from
     * @param to_handler The handler to handle the callback
     * @param status The status of the callback
     * @param sign_type The type of the signature
     * @param signatures The signatures of the callback
     */
    function receive_cross_chain_callback(
        uint256 txid,
        string memory from_chain,
        uint256 from_handler,
        address to_handler,
        CrossChainMsgStatus status,
        uint8 sign_type,
        bytes calldata signatures
    ) external {
        verifySignature(
            txid,
            from_handler,
            to_handler,
            status,
            sign_type,
            signatures
        );
        processCrossChainCallback(
            txid,
            from_chain,
            from_handler,
            to_handler,
            status,
            sign_type,
            signatures
        );
        emitCrossChainResult(txid);
    }

    function verifySignature(
        uint256 txid,
        uint256 from_handler,
        address to_handler,
        CrossChainMsgStatus status,
        uint8 sign_type,
        bytes calldata signatures
    ) internal view {
        bytes32 message_hash = keccak256(
            abi.encodePacked(txid, from_handler, to_handler, status)
        );

        require(
            signature_verifier.verify(message_hash, signatures, sign_type),
            "Invalid signature"
        );
    }

    function processCrossChainCallback(
        uint256 txid,
        string memory from_chain,
        uint256 from_handler,
        address to_handler,
        CrossChainMsgStatus status,
        uint8 sign_type,
        bytes calldata signatures
    ) internal {
        require(
            create_cross_txs[txid].status == CrossChainMsgStatus.Pending,
            "Invalid transaction status"
        );

        if (
            ISettlementHandler(to_handler).receive_cross_chain_callback(
                txid,
                from_chain,
                from_handler,
                status,
                sign_type,
                signatures
            )
        ) {
            create_cross_txs[txid].status = status;
        } else {
            create_cross_txs[txid].status = CrossChainMsgStatus.Failed;
        }
    }

    function emitCrossChainResult(uint256 txid) internal {
        emit CrossChainResult(
            txid,
            create_cross_txs[txid].from_chain,
            create_cross_txs[txid].to_chain,
            create_cross_txs[txid].from_address,
            create_cross_txs[txid].from_handler,
            create_cross_txs[txid].to_handler,
            create_cross_txs[txid].status
        );
    }
}
