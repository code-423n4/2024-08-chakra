import { expect } from "chai";
import {
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";

import hre from "hardhat";
import { Contract } from "ethers";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("ChakraSettlementHandler", function () {
    const chainId = 1;
    const chainName = "src"
    const requiredValidators = 2;
    const decimals = 8;
    const name = "MyToken"
    const symbol = "MKT"

    async function deploySettlementHandlerFixtureBase(mode: number) {
        const [
            tokenOwner,
            tokenOperator,
            verifierManager,
            settlementOwner,
            settlementHnadlerOwner,
        ] = await hre.ethers.getSigners();

        const ChakraToken = await hre.ethers.getContractFactory("ChakraToken");
        const tokenInstance = await hre.upgrades.deployProxy(ChakraToken, [
            await tokenOwner.getAddress(),
            await tokenOperator.getAddress(),
            name,
            symbol,
            decimals
        ]);

        const SettlementSignatureVerifier = await hre.ethers.getContractFactory("SettlementSignatureVerifier");
        const verifierInstance = await hre.upgrades.deployProxy(SettlementSignatureVerifier, [
            await verifierManager.getAddress(),
            requiredValidators
        ]);


        const SettlementTest = await hre.ethers.getContractFactory("SettlementTest");
        const settlmentInstance = await hre.upgrades.deployProxy(SettlementTest, [
            chainName,
            BigInt(chainId),
            await settlementOwner.getAddress(),
            await verifierInstance.getAddress(),
        ]);

        const ERC20CodecV1 = await hre.ethers.getContractFactory('ERC20CodecV1');
        const codecInstance = await hre.upgrades.deployProxy(ERC20CodecV1, [
            await settlementHnadlerOwner.getAddress(),
        ])
        const ERC20SettlementHandler = await hre.ethers.getContractFactory('ChakraSettlementHandler');
        const settlementHandlerInstance = await hre.upgrades.deployProxy(ERC20SettlementHandler, [
            await settlementHnadlerOwner.getAddress(), // owner
            mode, // mode
            chainName, //chain
            await tokenInstance.getAddress(), // token
            await codecInstance.getAddress(), // codec
            await verifierInstance.getAddress(), // verifier
            await settlmentInstance.getAddress(), // settlement

        ])

        const MessageLibTest = await hre.ethers.getContractFactory('MessageLibTest')
        const messageLibTestInstance = await MessageLibTest.deploy()

        return {
            tokenInstance,
            codecInstance,
            settlmentInstance,
            settlementHandlerInstance,
            messageLibTestInstance,
            verifierInstance,
            tokenOwner,
            tokenOperator,
            settlementOwner,
            settlementHnadlerOwner
        }
    }

    async function deploySettlementHandlerFixtureMintBurn() {
        return deploySettlementHandlerFixtureBase(0)
    }

    async function deploySettlementHandlerFixtureLockMint() {
        return deploySettlementHandlerFixtureBase(1)
    }

    async function deploySettlementHandlerFixtureBurnUnLock() {
        return deploySettlementHandlerFixtureBase(2)
    }

    async function deploySettlementHandlerFixtureLockUnlock() {
        return deploySettlementHandlerFixtureBase(3)
    }


    it('Should work in MintBurn mode', async () => {
        const [
            sender,
            receiver,
        ] = await hre.ethers.getSigners();
        const { tokenInstance, tokenOperator, codecInstance, settlmentInstance, tokenOwner, settlementHandlerInstance, settlementHnadlerOwner, messageLibTestInstance } = await loadFixture(deploySettlementHandlerFixtureMintBurn);

        const senderAddress = await sender.getAddress()
        const receiverAddress = await receiver.getAddress()
        const settlementHandlerAddress = await settlementHandlerInstance.getAddress()
        const totalAmount = 1000000;
        await tokenInstance.connect(tokenOperator).mint_to(sender, totalAmount);


        const toChain = "dst"
        const toHandler = 1
        const toToken = 1
        const receiverAddressU256 = hre.ethers.toBigInt(Buffer.from(receiverAddress.slice(2), 'hex'))
        const amount = 1000

        await tokenInstance.connect(sender).approve(settlementHandlerAddress, 1000)

        // 1. Test lock to settlement handler
        const tx = await settlementHandlerInstance.connect(sender).cross_chain_erc20_settlement(
            toChain,
            toHandler,
            toToken,
            receiverAddressU256,
            amount
        )

        // should lock 1000
        expect(await tokenInstance.balanceOf(senderAddress)).eq(totalAmount - amount)
        expect(await tokenInstance.balanceOf(settlementHandlerAddress)).eq(amount)

        const receipt = await tx.wait()
        const event = receipt.logs[2].args;


        const settlementHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(settlementHandlerAddress.slice(2), 'hex'))

        const payloadString = await messageLibTestInstance.encode_erc20_settlement_message(
            event[0],
            senderAddress,
            await codecInstance.getAddress(),
            await tokenInstance.getAddress(),
            await tokenInstance.getAddress(),
            receiverAddressU256,
            amount
        )
        const payload = Buffer.from(payloadString.slice(2), 'hex')

        // 2.Test receive_cross_chain_msg
        // let settlement as caller
        const settlementAddress = await settlmentInstance.getAddress()
        await hre.network.provider.request({
            method: "hardhat_impersonateAccount",
            params: [settlementAddress],
        });

        await hre.network.provider.send("hardhat_setBalance", [
            settlementAddress,
            "0x10000000000000000000000000000000000000000000000",
        ]);
        const settlementSigner = await hre.ethers.getSigner(settlementAddress);

        // 1. add invlaid from_handler to to_handler
        await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(chainName, settlementHandlerAddressU256)
        // 2. add minter/buner role for settlement
        await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerAddress);

        await settlementHandlerInstance.connect(settlementSigner).receive_cross_chain_msg(
            event[0],
            chainName,
            senderAddress,
            settlementHandlerAddressU256,
            5, // PayloadType.ERC20
            payload,
            0,
            Buffer.alloc(0)
        )

        expect(await tokenInstance.balanceOf(await receiver.getAddress())).eq(amount)


        // 3. Test callback
        // a. add to_handler to from_handler
        await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(toChain, settlementHandlerAddressU256)
        await settlementHandlerInstance.connect(settlementSigner).receive_cross_chain_callback(
            event[0],
            toChain,
            settlementHandlerAddressU256,
            2, // CrossChainMsgStatus.Success
            0, // sign_type
            Buffer.alloc(0) // signature
        )

        expect(await tokenInstance.totalSupply()).eq(totalAmount)

    });


    it('Should work in LockMint & BurnUnlock mode', async () => {
        const [
            sender,
            receiver,
        ] = await hre.ethers.getSigners();
        const { tokenInstance, tokenOperator, codecInstance, settlmentInstance, tokenOwner,
            settlementHandlerInstance, settlementHnadlerOwner, messageLibTestInstance } = await loadFixture(deploySettlementHandlerFixtureLockMint);

        const senderAddress = await sender.getAddress()
        const receiverAddress = await receiver.getAddress()
        const settlementHandlerAddress = await settlementHandlerInstance.getAddress()
        const totalAmount = 1000000;
        await tokenInstance.connect(tokenOperator).mint_to(sender, totalAmount);


        const toChain = "dst"
        const toHandler = 1
        const toToken = 1
        const receiverAddressU256 = hre.ethers.toBigInt(Buffer.from(receiverAddress.slice(2), 'hex'))
        const amount = 1000

        await tokenInstance.connect(sender).approve(settlementHandlerAddress, 1000)

        // 1. Test lock to settlement handler
        const tx = await settlementHandlerInstance.connect(sender).cross_chain_erc20_settlement(
            toChain,
            toHandler,
            toToken,
            receiverAddressU256,
            amount
        )

        expect(await tokenInstance.balanceOf(senderAddress)).eq(totalAmount - amount)
        expect(await tokenInstance.balanceOf(settlementHandlerAddress)).eq(amount)

        const receipt = await tx.wait()
        const event = receipt.logs[2].args;

        const settlementHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(settlementHandlerAddress.slice(2), 'hex'))

        const payloadString = await messageLibTestInstance.encode_erc20_settlement_message(
            event[0],
            senderAddress,
            await codecInstance.getAddress(),
            await tokenInstance.getAddress(),
            await tokenInstance.getAddress(),
            receiverAddressU256,
            amount
        )
        const payload = Buffer.from(payloadString.slice(2), 'hex')

        // 2. Test receive_cross_chain_msg
        {
            const { tokenInstance, tokenOperator, codecInstance, settlmentInstance, tokenOwner,
                settlementHandlerInstance, settlementHnadlerOwner, messageLibTestInstance } = await loadFixture(deploySettlementHandlerFixtureLockMint);

            const settlementAddress = await settlmentInstance.getAddress()
            await hre.network.provider.request({
                method: "hardhat_impersonateAccount",
                params: [settlementAddress],
            });

            await hre.network.provider.send("hardhat_setBalance", [
                settlementAddress,
                "0x10000000000000000000000000000000000000000000000",
            ]);
            const settlementSigner = await hre.ethers.getSigner(settlementAddress);

            // 1. add invlaid from_handler to to_handler
            await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(chainName, settlementHandlerAddressU256)
            // 2. add minter/buner role for settlement
            await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerAddress);

            await settlementHandlerInstance.connect(settlementSigner).receive_cross_chain_msg(
                event[0],
                chainName,
                senderAddress,
                settlementHandlerAddressU256, // from_handler
                5, // PayloadType.ERC20
                payload,
                0,
                Buffer.alloc(0)
            )

            expect(await tokenInstance.balanceOf(await receiver.getAddress())).eq(amount)
            expect(await tokenInstance.totalSupply()).eq(amount)
        }


        // 3. Test burn in destination handler
        {
            const [
                sender,
                receiver,
            ] = await hre.ethers.getSigners();

            const { tokenInstance, tokenOperator, codecInstance, settlmentInstance, tokenOwner,
                settlementHandlerInstance, settlementHnadlerOwner, messageLibTestInstance } = await loadFixture(deploySettlementHandlerFixtureBurnUnLock);

            await tokenInstance.connect(tokenOperator).mint_to(sender, amount)
            await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerInstance)


            // 1. add invlaid from_handler to to_handler
            await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(chainName, settlementHandlerAddressU256)
            // 2. add minter/buner role for settlement
            await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerAddress);

            const tx = await settlementHandlerInstance.connect(sender).cross_chain_erc20_settlement(
                toChain,
                settlementHandlerAddressU256, // to_handler
                toToken,
                receiverAddressU256,
                amount
            )

            expect(await tokenInstance.totalSupply()).eq(0)
        }
    });

    it('Should work in LockUnlock mode', async () => {
        const [
            sender,
            receiver,
        ] = await hre.ethers.getSigners();
        const { tokenInstance, tokenOperator, codecInstance, settlmentInstance, tokenOwner,
            settlementHandlerInstance, settlementHnadlerOwner, messageLibTestInstance } = await loadFixture(deploySettlementHandlerFixtureLockUnlock);

        const senderAddress = await sender.getAddress()
        const receiverAddress = await receiver.getAddress()
        const settlementHandlerAddress = await settlementHandlerInstance.getAddress()
        const settlementHandlerAddressU256 = hre.ethers.toBigInt(Buffer.from(settlementHandlerAddress.slice(2), 'hex'))
        const totalAmount = 1000000;
        await tokenInstance.connect(tokenOperator).mint_to(sender, totalAmount);


        const toChain = "dst"
        const toHandler = 1
        const toToken = 1
        const receiverAddressU256 = hre.ethers.toBigInt(Buffer.from(receiverAddress.slice(2), 'hex'))
        const amount = 1000

        await tokenInstance.connect(sender).approve(settlementHandlerAddress, amount)

        // 1. Test lock to settlement handler
        const tx = await settlementHandlerInstance.connect(sender).cross_chain_erc20_settlement(
            toChain,
            toHandler,
            toToken,
            receiverAddressU256,
            amount
        )

        expect(await tokenInstance.balanceOf(senderAddress)).eq(totalAmount - amount)
        expect(await tokenInstance.balanceOf(settlementHandlerAddress)).eq(amount)

        const receipt = await tx.wait()
        const event = receipt.logs[2].args;

        // 2. Test receive_cross_chain_msg unlock
        {

            const payloadString = await messageLibTestInstance.encode_erc20_settlement_message(
                event[0],
                senderAddress,
                await codecInstance.getAddress(),
                await tokenInstance.getAddress(),
                await tokenInstance.getAddress(),
                receiverAddressU256,
                amount
            )
            const payload = Buffer.from(payloadString.slice(2), 'hex')


            const settlementAddress = await settlmentInstance.getAddress()
            await hre.network.provider.request({
                method: "hardhat_impersonateAccount",
                params: [settlementAddress],
            });

            await hre.network.provider.send("hardhat_setBalance", [
                settlementAddress,
                "0x10000000000000000000000000000000000000000000000",
            ]);
            const settlementSigner = await hre.ethers.getSigner(settlementAddress);

            // 1. add invlaid from_handler to to_handler
            await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(chainName, settlementHandlerAddressU256)
            // 2. add minter/buner role for settlement
            await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerAddress);

            await settlementHandlerInstance.connect(settlementSigner).receive_cross_chain_msg(
                event[0],
                chainName,
                senderAddress,
                settlementHandlerAddressU256, // from_handler
                5, // PayloadType.ERC20
                payload,
                0,
                Buffer.alloc(0)
            )

            expect(await tokenInstance.balanceOf(await receiver.getAddress())).eq(amount)
            expect(await tokenInstance.balanceOf(settlementHandlerAddress)).eq(0)
        }


        // 3. Test burn in destination handler
        {
            const [
                sender,
                receiver,
            ] = await hre.ethers.getSigners();

            const { tokenInstance, tokenOperator, codecInstance, settlmentInstance, tokenOwner,
                settlementHandlerInstance, settlementHnadlerOwner, messageLibTestInstance } = await loadFixture(deploySettlementHandlerFixtureBurnUnLock);

            await tokenInstance.connect(tokenOperator).mint_to(sender, amount)
            await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerInstance)


            // 1. add invlaid from_handler to to_handler
            await settlementHandlerInstance.connect(settlementHnadlerOwner).add_handler(chainName, settlementHandlerAddressU256)
            // 2. add minter/buner role for settlement
            await tokenInstance.connect(tokenOwner).add_operator(settlementHandlerAddress);

            const tx = await settlementHandlerInstance.connect(sender).cross_chain_erc20_settlement(
                toChain,
                settlementHandlerAddressU256, // to_handler
                toToken,
                receiverAddressU256,
                amount
            )

            expect(await tokenInstance.totalSupply()).eq(0)
        }
    });
});
