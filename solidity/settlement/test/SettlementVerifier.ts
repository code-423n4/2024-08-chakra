import { expect } from "chai";
import {
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";

import hre from "hardhat";
import { Contract } from "ethers";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("Settlement", function () {
    const requiredValidators = 2;

    async function deploySettlementFixture() {
        const [
            verifierOwner,
        ] = await hre.ethers.getSigners();

        const SettlementSignatureVerifie = await hre.ethers.getContractFactory("SettlementSignatureVerifier");
        const verifyInstance = await hre.upgrades.deployProxy(SettlementSignatureVerifie, [
            await verifierOwner.getAddress(),
            requiredValidators
        ]);
        return { verifyInstance, verifierOwner }
    }



    it("SettlementVerifier should verified", async function () {
        const [validator1, validator2, validator3, manager] = await hre.ethers.getSigners();
        const { verifyInstance, verifierOwner } = await loadFixture(deploySettlementFixture)

        // Add the settlement contract as a manager
        await verifyInstance.connect(verifierOwner).add_manager(await manager.getAddress());

        const validators = [validator1, validator2, validator3]

        // Make a message hash
        const messageHash = hre.ethers.solidityPackedKeccak256(["address", "string"], [await verifyInstance.getAddress(), "test message"])

        for (let i = 0; i < validators.length; i++) {
            await verifyInstance.connect(manager).add_validator(await validators[i].getAddress());
        }


        let signatures = Buffer.from([]);
        for (let i = 0; i < validators.length - 1; i++) {
            const signature = await validators[i].signMessage(hre.ethers.getBytes(messageHash));
            const signatureBytes = Buffer.from(signature.slice(2), 'hex');
            signatures = Buffer.concat([signatures, signatureBytes]);
        }

        expect(await verifyInstance.verify(messageHash, signatures, 0)).to.equal(true);
    });
});
