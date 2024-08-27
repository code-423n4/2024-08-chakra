// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ISettlement} from "contracts/interfaces/ISettlement.sol";
import {IERC20CodecV1} from "contracts/interfaces/IERC20CodecV1.sol";
import {ISettlementSignatureVerifier} from "contracts/interfaces/ISettlementSignatureVerifier.sol";
import {AddressCast} from "contracts/libraries/AddressCast.sol";
import {Message, PayloadType} from "contracts/libraries/Message.sol";
import {MessageV1Codec} from "contracts/libraries/MessageV1Codec.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "contracts/libraries/ERC20Payload.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

abstract contract BaseSettlementHandler is
    OwnableUpgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable
{
    enum CrossChainTxStatus {
        Unknow,
        Pending,
        Minted,
        Settled,
        Failed
    }

    /**
     * @dev The settlement token mode
     */
    enum SettlementMode {
        MintBurn,
        LockMint,
        BurnUnlock,
        LockUnlock
    }

    event CrossChainLocked(
        uint256 indexed txid,
        address indexed from,
        uint256 indexed to,
        string from_chain,
        string to_chain,
        address from_token,
        uint256 to_token,
        uint256 amount,
        SettlementMode mode
    );

    struct CreatedCrossChainTx {
        uint256 txid;
        string from_chain;
        string to_chain;
        address from;
        uint256 to;
        address from_token;
        uint256 to_token;
        uint256 amount;
        CrossChainTxStatus status;
    }

    // =============== Contracts ============================================================
    SettlementMode public mode;
    /**
     * @dev The address of the token contract
     */
    address public token;

    /**
     * @dev The address of the verify contract
     */
    ISettlementSignatureVerifier public verifier;

    /**
     * @dev The address of the settlement contract
     */
    ISettlement public settlement;

    // =============== Storages ============================================================
    mapping(address => uint256) public nonce_manager;
    mapping(uint256 => CreatedCrossChainTx) public create_cross_txs;
    uint64 public cross_chain_msg_id_counter;
    /**
     * @dev The chain name
     */
    string public chain;

    event SentCrossSettlementMsg(
        uint256 txid,
        string from_chain,
        string to_chain,
        address from_handler,
        address to_handler,
        bytes payload
    );

    enum HandlerStatus {
        Unknow,
        Pending,
        Success,
        Failed
    }

    struct HandlerTransaction {
        HandlerStatus status;
    }

    mapping(uint256 => HandlerTransaction) public handler_transactions;

    function _Settlement_handler_init(
        address _owner,
        SettlementMode _mode,
        address _token,
        address _verifier,
        string memory _chain,
        address _settlement
    ) public {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
        settlement = ISettlement(_settlement);
        verifier = ISettlementSignatureVerifier(_verifier);
        mode = _mode;
        token = _token;
        chain = _chain;
    }

    modifier onlySettlement() {
        require(msg.sender == address(settlement), "Not chakra settlement");
        _;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
