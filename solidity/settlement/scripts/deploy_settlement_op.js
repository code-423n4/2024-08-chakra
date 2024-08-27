const hre = require("hardhat");
const { task } = require('hardhat/config')


async function main() {
    const settlementOwner = "0x2d758a7D719e588C0fc17EcC557aCea37ca9a557"
    const settlementMansgers = ["0x2d758a7D719e588C0fc17EcC557aCea37ca9a557"]

    const newSettlement = await ethers.getContractFactory("ChakraSettlement"); // Replace with your new contract name

    const chainId = 10
    const requiredValidators = 1
    const chainName = "Optimism"
    const _signature_verifier = "0xA4Ba5728b519e30B5DF3D907fF843E63C25e9703";

    const settlmentInstance = await hre.upgrades.deployProxy(newSettlement, [
        chainName,
        chainId,
        settlementOwner,
        settlementMansgers,
        BigInt(requiredValidators),
        _signature_verifier,
    ]);

    await settlmentInstance.waitForDeployment();
    console.log("Settlement contract deployed to: ", await settlmentInstance.getAddress())
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});