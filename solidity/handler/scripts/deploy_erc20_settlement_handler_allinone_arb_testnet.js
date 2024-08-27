// scripts/deploy-my-collectible.js
const hre = require("hardhat");
const { task } = require('hardhat/config')


async function main() {
    // 1. Deploy Token Contract
    const tokenOwner = "0x1E6c3eed532d4a3937FBE178909739E60A327e19"
    const tokenOperator = "0x1E6c3eed532d4a3937FBE178909739E60A327e19"
    const decimals = 8
    const name = "MyToken"
    const symbol = "MKT"
    const ChakraBTC = await hre.ethers.getContractFactory("ChakraToken")
    const tokenInstance = await hre.upgrades.deployProxy(ChakraBTC, [tokenOwner, tokenOperator, name, symbol, decimals]);
    await tokenInstance.waitForDeployment();
    const tokenAddress = await tokenInstance.getAddress();
    console.log("ChakraBTC contract deployed to: ", tokenAddress)


    // 2. Deploy Codec Contract
    const codecOwner = "0x1E6c3eed532d4a3937FBE178909739E60A327e19"
    const ERC20CodecV1 = await hre.ethers.getContractFactory("ERC20CodecV1");
    const codecInstance = await hre.upgrades.deployProxy(ERC20CodecV1, [codecOwner]);
    await codecInstance.waitForDeployment();
    console.log("Codec contract deployed to: ", await codecInstance.getAddress())


    // 3. Deploy Verify Contract
    const verifyOwner = "0x1E6c3eed532d4a3937FBE178909739E60A327e19"
    const VerifyV1 = await hre.ethers.getContractFactory("SettlementSignatureVerifier");
    const verifyInstance = await hre.upgrades.deployProxy(VerifyV1, [verifyOwner, 1]);
    await verifyInstance.waitForDeployment();
    console.log("Verify contract deployed to: ", await verifyInstance.getAddress())

    // 4. Deploy SettlementHandler Contract
    const no_burn = true;
    const chain = "Arbitrum"
    const settlementContractAddress = "0xd56A32F635427287861Da716A442CfA7834e9463"
    const settlementHandlerOwner = "0x1E6c3eed532d4a3937FBE178909739E60A327e19"
    const ERC20SettlementHandler = await hre.ethers.getContractFactory("ChakraSettlementHandler");
    const settlementHandlerInstance = await hre.upgrades.deployProxy(ERC20SettlementHandler, [
        settlementHandlerOwner,
        no_burn,
        chain,
        await tokenInstance.getAddress(),
        await codecInstance.getAddress(),
        await verifyInstance.getAddress(),
        settlementContractAddress
    ]);

    await settlementHandlerInstance.waitForDeployment();
    console.log("SettlementHandler contract deployed to: ", await settlementHandlerInstance.getAddress())
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});