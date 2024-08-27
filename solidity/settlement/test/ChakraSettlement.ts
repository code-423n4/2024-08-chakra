import { expect } from "chai";
import {
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";

import hre from "hardhat";
import { Contract } from "ethers";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("ChakraSettlement", function () {
    const chainId = 1;
    const chainName = "test"
    const requiredValidators = 2;
    const decimals = 8;
    const name = "MyToken"
    const symbol = "MKT"
    const noBurn = false;

    async function deploySettlementFixture() {
        const [
            tokenOwner,
            tokenOperator,
            manager,
            settlementOwner,
            settlementHnadlerOwner,
        ] = await hre.ethers.getSigners();
        const MyToken = await hre.ethers.getContractFactory("MyToken");
        const tokenInstance = await hre.upgrades.deployProxy(MyToken, [
            await tokenOwner.getAddress(),
            await tokenOperator.getAddress(),
            name,
            symbol,
            decimals
        ]);

        const SettlementSignatureVerifier = await hre.ethers.getContractFactory("SettlementSignatureVerifier");
        const verifierInstance = await hre.upgrades.deployProxy(SettlementSignatureVerifier, [
            await settlementOwner.getAddress(),
            requiredValidators
        ]);


        const ChakraSettlement = await hre.ethers.getContractFactory("ChakraSettlement");
        const settlmentInstance = await hre.upgrades.deployProxy(ChakraSettlement, [
            chainName,
            BigInt(chainId),
            await settlementOwner.getAddress(),
            [await manager.getAddress()],
            BigInt(requiredValidators),
            await verifierInstance.getAddress(),
        ]);

        const ERC20CodecV1 = await hre.ethers.getContractFactory('ERC20CodecV1');
        const codecInstance = await hre.upgrades.deployProxy(ERC20CodecV1, [
            await settlementHnadlerOwner.getAddress(),
        ])
        const ERC20SettlementHandler = await hre.ethers.getContractFactory('ERC20SettlementHandler');
        const settlementHandlerInstance = await hre.upgrades.deployProxy(ERC20SettlementHandler, [
            await settlementHnadlerOwner.getAddress(), // owner
            noBurn, // no_burn
            chainName, //chain
            await tokenInstance.getAddress(), // token
            await codecInstance.getAddress(), // codec
            await verifierInstance.getAddress(), // verifier
            await settlmentInstance.getAddress(), // settlement

        ])

        const MessageLibTest = await hre.ethers.getContractFactory('MessageLibTest')
        const messageLibTestInstance = await MessageLibTest.deploy()

        // Approval operator role
        await tokenInstance.connect(tokenOwner).add_operator(await settlementHandlerInstance.getAddress())

        return { tokenInstance, codecInstance, settlmentInstance, settlementHandlerInstance, verifierInstance, messageLibTestInstance, tokenOwner, tokenOperator, manager, settlementOwner, settlementHnadlerOwner }
    }

    it('Should upgrade to version 2', async () => {
        const { settlmentInstance, settlementOwner } = await loadFixture(deploySettlementFixture);

        expect(await settlmentInstance.version()).to.equal("0.1.0")

        const instanceV2 = await hre.ethers.getContractFactory("ChakraSettlementUpgradeTest");

        const upgraded = await hre.upgrades.upgradeProxy(await settlmentInstance.getAddress(), instanceV2.connect(settlementOwner));

        const upgraded_owner = await upgraded.owner();
        expect(upgraded_owner.toString()).to.equal(await settlementOwner.getAddress());

        expect(await upgraded.version()).to.equal("0.1.1");
    });

    it("Should management manager", async function () {
        const [maanger] = await hre.ethers.getSigners();
        const { tokenInstance, settlmentInstance, settlementHandlerInstance, codecInstance, verifierInstance, messageLibTestInstance, manager, settlementOwner } = await loadFixture(deploySettlementFixture)

        const managerAddress = await manager.getAddress();

        // Only owner can management manager
        await expect(settlmentInstance.add_manager(managerAddress)).to.revertedWithCustomError(settlmentInstance, "OwnableUnauthorizedAccount")
        await expect(settlmentInstance.remove_manager(managerAddress)).to.revertedWithCustomError(settlmentInstance, "OwnableUnauthorizedAccount")

        // Add and remove manager after that manager state should correctly
        await settlmentInstance.connect(settlementOwner).add_manager(managerAddress)
        expect(await settlmentInstance.is_manager(managerAddress)).to.equal(true)

        await settlmentInstance.connect(settlementOwner).remove_manager(managerAddress)
        expect(await settlmentInstance.is_manager(managerAddress)).to.equal(false)

    })

    it("Should managed validators correctly", async function () {
        const [validator1, validator2, validator3] = await hre.ethers.getSigners();
        const { settlmentInstance, verifierInstance, manager, settlementOwner } = await loadFixture(deploySettlementFixture)

        // Add the settlement contract as a manager
        await verifierInstance.connect(settlementOwner).add_manager(await settlmentInstance.getAddress());


        const validators = [validator1, validator2, validator3]

        // Check that the validators are correctly added
        for (let i = 0; i < validators.length; i++) {
            await settlmentInstance.connect(manager).add_validator(await validators[i].getAddress());
            expect(await settlmentInstance.is_validator(await validators[i].getAddress())).to.equal(true);
            expect(await verifierInstance.is_validator(await validators[i].getAddress())).to.equal(true);
        }

        // Check that the validators added but not allow added again
        for (let i = 0; i < validators.length; i++) {
            await expect(settlmentInstance.connect(manager).add_validator(await validators[i].getAddress()))
                .to.be.revertedWith("Validator already exists")
        }


        // Check that the validators are correctly removed
        for (let i = 0; i < validators.length; i++) {
            await settlmentInstance.connect(manager).remove_validator(await validators[i].getAddress());
            expect(await settlmentInstance.is_validator(await validators[i].getAddress())).to.equal(false);
            expect(await verifierInstance.is_validator(await validators[i].getAddress())).to.equal(false);
        }

        // Check that the validators removed but not allow removed again
        for (let i = 0; i < validators.length; i++) {
            await expect(settlmentInstance.connect(manager).remove_validator(await validators[i].getAddress()))
                .to.be.revertedWith("Validator does not exists")
        }
    });

    it("Should send cross chain message", async function () {
        const [sender, receiver, fromHandler] = await hre.ethers.getSigners();
        const { tokenInstance, settlmentInstance, settlementHandlerInstance, codecInstance, verifierInstance, messageLibTestInstance, manager, settlementOwner } = await loadFixture(deploySettlementFixture)

        const senderAddress = await sender.getAddress()
        const receiverAddress = await receiver.getAddress()
        const receiverAddressU256 = hre.ethers.toBigInt(Buffer.from(receiverAddress.slice(2), 'hex'))
        const settlementHandlerAddress = await settlementHandlerInstance.getAddress()
        const settlementHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(settlementHandlerAddress.slice(2), 'hex'))
        const msgId = 1
        const amount = 1000
        const toChain = "Starknet"
        const payloadString = await messageLibTestInstance.encode_erc20_settlement_message(
            msgId,
            senderAddress,
            await codecInstance.getAddress(),
            await tokenInstance.getAddress(),
            await tokenInstance.getAddress(),
            receiverAddressU256,
            amount
        )
        const payload = Buffer.from(payloadString.slice(2), 'hex')

        const tx = await settlmentInstance.connect(fromHandler).send_cross_chain_msg(
            toChain,
            senderAddress,
            settlementHandlerAddressU256, // to handler
            5, // ERC20
            payload
        )


        const txid = hre.ethers.solidityPackedKeccak256(
            ["string", "string", "address", "address", "uint256", "uint256", "uint8", "bytes"],
            [
                chainName,
                toChain,
                senderAddress,
                await fromHandler.getAddress(),
                settlementHandlerAddressU256,
                1,
                5,
                payload
            ]
        )

        const txidU256 = hre.ethers.toBigInt(Buffer.from(txid.slice(2), 'hex'))

        await expect(tx).emit(settlmentInstance, 'CrossChainMsg')
            .withArgs(
                txidU256,
                senderAddress,
                chainName,
                toChain,
                await fromHandler.getAddress(),
                settlementHandlerAddressU256,
                5,
                payload
            )
    })

    it("Should receive cross chain message", async function () {
        const [sender, receiver, fromHandler, validator1, validator2, validator3] = await hre.ethers.getSigners();
        const { tokenInstance, settlmentInstance, settlementHandlerInstance, codecInstance, verifierInstance, messageLibTestInstance, manager, settlementOwner, settlementHnadlerOwner } = await loadFixture(deploySettlementFixture)


        const senderAddress = await sender.getAddress()
        const senderAddressU256 = hre.ethers.toBigInt(Buffer.from(senderAddress.slice(2), 'hex'))
        const receiverAddress = await receiver.getAddress()
        const receiverAddressU256 = hre.ethers.toBigInt(Buffer.from(receiverAddress.slice(2), 'hex'))
        const settlementHandlerAddress = await settlementHandlerInstance.getAddress()
        const settlementHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(settlementHandlerAddress.slice(2), 'hex'))
        const fromHandlerAddress = await fromHandler.getAddress();
        const fromHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(fromHandlerAddress.slice(2), 'hex'))

        const msgId = 1
        const amount = 1000
        const toChain = "Starknet"

        // Add the settlement contract as a manager
        await verifierInstance.connect(settlementOwner).add_manager(await settlmentInstance.getAddress());

        // Add from handler to receive handler whitelist
        await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(
            chainName,
            fromHandlerAddressU256
        );

        // Make erc20 message payload
        const payloadString = await messageLibTestInstance.encode_erc20_settlement_message(
            hre.ethers.toBigInt(msgId),
            senderAddress,
            await codecInstance.getAddress(),
            await tokenInstance.getAddress(),
            await tokenInstance.getAddress(),
            receiverAddressU256,
            hre.ethers.toBigInt(amount)
        )
        const payload = Buffer.from(payloadString.slice(2), 'hex')
        const payloadKeccak256Bytes = Buffer.from(hre.ethers.keccak256(payload).slice(2), 'hex')
        await settlmentInstance.connect(fromHandler).send_cross_chain_msg(
            toChain,
            senderAddress,
            settlementHandlerAddressU256, // to handler
            5, // ERC20
            payload
        )


        const txid = hre.ethers.solidityPackedKeccak256(
            ["string", "string", "address", "address", "uint256", "uint256", "uint8", "bytes"],
            [
                chainName,
                toChain,
                senderAddress,
                await fromHandler.getAddress(),
                settlementHandlerAddressU256,
                1,
                5,
                payload
            ]
        )

        const txidU256 = hre.ethers.toBigInt(Buffer.from(txid.slice(2), 'hex'))


        const validators = [validator1, validator2, validator3]
        for (let i = 0; i < validators.length; i++) {
            await settlmentInstance.connect(manager).add_validator(await validators[i].getAddress());
        }

        // Make multisignature
        const messageHash = hre.ethers.solidityPackedKeccak256(
            ["uint256", "string", "uint256", "uint256", "address", "bytes32"],
            [
                txid,
                chainName,
                senderAddressU256,
                fromHandlerAddressU256,
                settlementHandlerAddress,
                payloadKeccak256Bytes
            ])
        let signatures = Buffer.from([]);
        for (let i = 0; i < validators.length - 1; i++) {
            const signature = await validators[i].signMessage(hre.ethers.getBytes(messageHash));
            const signatureBytes = Buffer.from(signature.slice(2), 'hex');
            signatures = Buffer.concat([signatures, signatureBytes]);
        }

        await settlmentInstance.connect(validator1).receive_cross_chain_msg(
            txidU256,
            chainName,
            senderAddressU256,
            fromHandlerAddressU256,
            settlementHandlerAddress,
            5,
            payload,
            0,
            signatures
        );

        expect(await tokenInstance.balanceOf(receiverAddress)).to.be.equal(amount)
    })

    it("Should receive cross chain callback", async function () {
        const [sender, receiver, fromHandler, toHandler, validator1, validator2, validator3] = await hre.ethers.getSigners();
        const { tokenInstance, settlmentInstance, settlementHandlerInstance, codecInstance, verifierInstance, messageLibTestInstance, manager, tokenOperator, settlementOwner, settlementHnadlerOwner } = await loadFixture(deploySettlementFixture)


        const toTokenAddress = await sender.getAddress()
        const toTokenAddressU256 = hre.ethers.toBigInt(Buffer.from(toTokenAddress.slice(2), 'hex'))
        const senderAddress = await sender.getAddress()
        const senderAddressU256 = hre.ethers.toBigInt(Buffer.from(senderAddress.slice(2), 'hex'))
        const receiverAddress = await receiver.getAddress()
        const receiverAddressU256 = hre.ethers.toBigInt(Buffer.from(receiverAddress.slice(2), 'hex'))
        const settlementHandlerAddress = await settlementHandlerInstance.getAddress()
        const settlementHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(settlementHandlerAddress.slice(2), 'hex'))
        const fromHandlerAddress = await fromHandler.getAddress();
        const fromHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(fromHandlerAddress.slice(2), 'hex'))
        const toHandlerAddress = await toHandler.getAddress();
        const toHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(toHandlerAddress.slice(2), 'hex'))

        const amount = 1000
        const toChain = "Starknet"

        // Mint some token to sender and approve this that sender can lock some fund to settlement handler
        await tokenInstance.connect(tokenOperator).mint_to(senderAddress, amount)
        await tokenInstance.connect(sender).approve(await settlementHandlerInstance.getAddress(), amount)

        // Add the settlement contract as a manager
        await verifierInstance.connect(settlementOwner).add_manager(await settlmentInstance.getAddress());

        // Add the validators
        const validators = [validator1, validator2, validator3]
        for (let i = 0; i < validators.length; i++) {
            await settlmentInstance.connect(manager).add_validator(await validators[i].getAddress());
        }


        // Add from handler to receive handler whitelist
        await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(
            chainName,
            fromHandlerAddressU256
        );

        const tx = await settlementHandlerInstance.connect(sender)
            .cross_chain_erc20_settlement(
                toChain,
                settlementHandlerAddressU256, // to handler
                toTokenAddressU256,
                receiverAddressU256,
                amount
            );



        // Make erc20 message payload
        const crossChainMsgId = hre.ethers.solidityPackedKeccak256(
            ["uint64", "address", "address", "uint256"],
            [
                1,
                settlementHandlerAddress,
                senderAddress,
                1
            ]
        )
        const crossChainMsgIdU256 = hre.ethers.toBigInt(Buffer.from(crossChainMsgId.slice(2), 'hex'))
        const payloadString = await messageLibTestInstance.encode_erc20_settlement_message(
            crossChainMsgIdU256,
            senderAddress,
            await codecInstance.getAddress(),
            await tokenInstance.getAddress(),
            toTokenAddressU256,
            receiverAddressU256,
            amount
        )
        const payload = Buffer.from(payloadString.slice(2), 'hex')
        const payloadKeccak256Bytes = Buffer.from(hre.ethers.keccak256(payload).slice(2), 'hex')


        const txid = hre.ethers.solidityPackedKeccak256(
            ["string", "string", "address", "address", "uint256", "uint256", "uint8", "bytes"],
            [
                chainName,
                toChain,
                senderAddress,
                settlementHandlerAddress,
                settlementHandlerAddressU256, // to handler
                1,
                5, // payload type
                payload, // payload
            ]
        )

        const txidU256 = hre.ethers.toBigInt(Buffer.from(txid.slice(2), 'hex'))





        await expect(tx).emit(settlementHandlerInstance, 'CrossChainLocked').withArgs(
            txidU256,
            senderAddress,
            receiverAddressU256,
            chainName,
            toChain,
            await settlementHandlerInstance.getAddress(),
            toTokenAddressU256,
            amount,
            payload
        );


        const settleTxid = hre.ethers.solidityPackedKeccak256(
            ["string", "string", "address", "address", "uint256", "uint256", "uint8", "bytes"],
            [
                chainName,
                toChain,
                senderAddress,
                settlementHandlerAddress,
                settlementHandlerAddressU256,
                1,
                5,
                payload
            ]
        )

        const settleTxidU256 = hre.ethers.toBigInt(Buffer.from(settleTxid.slice(2), 'hex'))

        const tmp = await settlementHandlerInstance.cross_chain_settlement_txs(txidU256)
        // Make multisignature
        const messageHash = hre.ethers.solidityPackedKeccak256(
            ["uint256", "uint256", "address", "uint8"],
            [
                settleTxidU256,
                settlementHandlerAddressU256, // from handler
                settlementHandlerAddress, // to handler
                2 // CrossChainStatus
            ])
        let signatures = Buffer.from([]);
        for (let i = 0; i < validators.length - 1; i++) {
            const signature = await validators[i].signMessage(hre.ethers.getBytes(messageHash));
            const signatureBytes = Buffer.from(signature.slice(2), 'hex');
            signatures = Buffer.concat([signatures, signatureBytes]);
        }

        await settlmentInstance.connect(validator1)
            .receive_cross_chain_callback(
                settleTxidU256,
                toChain,
                settlementHandlerAddressU256,
                settlementHandlerAddress, // to handler
                2,
                0,
                signatures
            )
        // await settlementHandlerInstance
        //     .receive_cross_chain_callback(
        //         txidU256,
        //         senderAddress,
        //         receiverAddressU256,
        //         chainName,
        //         toChain,
        //         await settlementHandlerInstance.getAddress(),
        //         toTokenAddressU256,
        //         amount,
        //         payload
        //     )



        // await settlmentInstance.connect(validator1).receive_cross_chain_msg(
        //     txidU256,
        //     chainName,
        //     senderAddressU256,
        //     fromHandlerAddressU256,
        //     settlementHandlerAddress,
        //     5,
        //     payload,
        //     0,
        //     signatures
        // );

        // expect(await tokenInstance.balanceOf(receiverAddress)).to.be.equal(amount)
    })
});
