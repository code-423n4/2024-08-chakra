// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ISettlement} from "contracts/interfaces/ISettlement.sol";
import {IERC20CodecV1} from "contracts/tests/IERC20CodecV1.t.sol";
import {IERC20Mint} from "contracts/interfaces/IERC20Mint.sol";
import {IERC20Burn} from "contracts/interfaces/IERC20Burn.sol";
import {ISettlementHandler} from "contracts/interfaces/ISettlementHandler.sol";
import {AddressCast} from "contracts/libraries/AddressCast.sol";
import {Message, PayloadType, CrossChainMsgStatus} from "contracts/libraries/Message.sol";
import {MessageV1Codec} from "contracts/libraries/MessageV1Codec.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BaseSettlementHandler} from "contracts/tests/BaseSettlementHandler.t.sol";
import "contracts/tests/ERC20Payload.t.sol";

contract ERC20SettlementHandler is BaseSettlementHandler, ISettlementHandler {
    struct CrossChainSettlementTx {
        uint256 txid;
        string to_chain;
        address from;
        uint256 to;
        uint256 to_token;
        uint256 to_handler;
        uint256 amount;
        CrossChainTxStatus status;
    }

    // =============== Contracts ============================================================
    /**
     * @dev The address of the codec contract
     */
    IERC20CodecV1 public codec;

    // =============== Storages ============================================================
    mapping(uint256 => CrossChainSettlementTx)
        public cross_chain_settlement_txs;

    function initialize(
        address _owner,
        bool _no_burn,
        string memory _chain,
        address _token,
        address _codec,
        address _verifier,
        address _settlement
    ) public initializer {
        _Settlement_handler_init(
            _owner,
            _no_burn,
            _token,
            _verifier,
            _chain,
            _settlement
        );
        codec = IERC20CodecV1(_codec);
    }

    function cross_chain_erc20_settlement(
        string memory to_chain,
        uint256 to_handler,
        uint256 to_token,
        uint256 to,
        uint256 amount
    ) external {
        require(amount > 0, "Amount must be greater than 0");
        require(to != 0, "Invalid to address");
        require(to_handler != 0, "Invalid to handler address");
        require(to_token != 0, "Invalid to token address");

        require(
            IERC20(token).balanceOf(msg.sender) >= amount,
            "Insufficient balance"
        );

        // transfer tokens
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Increment nonce for the sender
        nonce_manager[msg.sender] += 1;

        // Create a new cross chain msg id
        cross_chain_msg_id_counter += 1;
        uint256 cross_chain_msg_id = uint256(
            keccak256(
                abi.encodePacked(
                    cross_chain_msg_id_counter,
                    address(this),
                    msg.sender,
                    nonce_manager[msg.sender]
                )
            )
        );

        // Create a erc20 transfer payload
        ERC20TransferPayload memory payload = ERC20TransferPayload(
            ERC20Method.Transfer,
            AddressCast.to_uint256(msg.sender),
            to,
            AddressCast.to_uint256(token),
            to_token,
            amount
        );

        // Create a cross chain msg
        Message memory cross_chain_msg = Message(
            cross_chain_msg_id,
            PayloadType.ERC20,
            codec.encode_transfer(payload)
        );

        // Encode the cross chain msg
        bytes memory cross_chain_msg_bytes = MessageV1Codec.encode(
            cross_chain_msg
        );

        // Create a new cross chain tx
        uint256 txid = uint256(
            keccak256(
                abi.encodePacked(
                    chain,
                    to_chain,
                    msg.sender, // from address for settlement to calculate txid
                    address(this), //  from handler for settlement to calculate txid
                    to_handler,
                    nonce_manager[msg.sender]
                )
            )
        );

        // Save the cross chain tx
        cross_chain_settlement_txs[txid] = CrossChainSettlementTx(
            txid,
            to_chain,
            msg.sender,
            to,
            to_token,
            to_handler,
            amount,
            CrossChainTxStatus.Pending
        );

        // Send the cross chain msg
        settlement.send_cross_chain_msg(
            to_chain,
            msg.sender,
            to_handler,
            PayloadType.ERC20,
            cross_chain_msg_bytes
        );

        emit CrossChainLocked(
            txid,
            msg.sender,
            to,
            chain,
            to_chain,
            address(this),
            to_token,
            amount,
            cross_chain_msg_bytes
        );
    }

    function receive_cross_chain_msg(
        uint256 /**txid */,
        string memory from_chain,
        uint256 /**from_address */,
        uint256 from_handler,
        PayloadType payload_type,
        bytes calldata payload,
        uint8 /**sign type */,
        bytes calldata /**signaturs */
    ) external returns (bool) {
        //  from_handler need in whitelist
        if (!is_valid_handler(from_chain, from_handler)) {
            return false;
        }

        require(payload_type == PayloadType.ERC20, "Invalid payload type");

        bytes memory erc20_payload = MessageV1Codec.payload(payload);

        // Decode payload method
        ERC20Method method = codec.decode_method(erc20_payload);

        // Cross chain transfer
        {
            if (method == ERC20Method.Transfer) {
                // Decode transfer payload
                ERC20TransferPayload memory transfer_payload = codec
                    .deocde_transfer(erc20_payload);

                if (no_burn) {
                    require(
                        IERC20(token).balanceOf(address(this)) >=
                            transfer_payload.amount,
                        "Insufficient balance"
                    );

                    IERC20(token).transfer(
                        AddressCast.to_address(transfer_payload.to),
                        transfer_payload.amount
                    );
                } else {
                    IERC20Mint(token).mint_to(
                        AddressCast.to_address(transfer_payload.to),
                        transfer_payload.amount
                    );
                }

                return true;
            }
        }

        return false;
    }

    function receive_cross_chain_callback(
        uint256 txid,
        string memory from_chain,
        uint256 from_handler,
        CrossChainMsgStatus status,
        uint8 sign_type, // validators signature type /  multisig or bls sr25519
        bytes calldata signatures
    ) external returns (bool) {
        require(
            keccak256(
                abi.encodePacked(cross_chain_settlement_txs[txid].to_chain)
            ) == keccak256(abi.encodePacked(from_chain)),
            "Invalid from chain"
        );

        require(
            cross_chain_settlement_txs[txid].to_handler == from_handler,
            "Invalid from handler"
        );

        bytes32 message_hash = keccak256(
            abi.encodePacked(txid, from_handler, address(this), status)
        );
        require(
            verifier.verify(message_hash, signatures, sign_type),
            "Invalid signature"
        );

        if (no_burn) {
            IERC20Burn(token).burn(cross_chain_settlement_txs[txid].amount);
        }

        cross_chain_settlement_txs[txid].status = CrossChainTxStatus.Settled;

        return true;
    }
}
