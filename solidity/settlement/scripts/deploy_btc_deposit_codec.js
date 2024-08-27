const hre = require("hardhat");
const { task } = require('hardhat/config')


async function main() {
    const settlementOwner = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"

    const newCodec = await ethers.getContractFactory("BtcDepositCodec"); // Replace with your new contract name

    const contractInstance = await hre.upgrades.deployProxy(newCodec, [
        settlementOwner
    ]);

    await contractInstance.waitForDeployment();
    console.log("BtcDepositCodec contract deployed to: ", await contractInstance.getAddress())
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});