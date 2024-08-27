import hre from "hardhat";

import { expect } from "chai";
import { ChakraToken } from "../typechain";

describe("ChakraToken", function () {
  let owner: any;
  let operator: any;
  let otherAccount: any;
  let chakraTokenObject: ChakraToken;

  const name: string = "ChakraToken";
  const symbol: string = "ckrBTC";
  const decimals = 8;

  async function deployERC20Fixture() {
    const [deployer, owner, operator] = await hre.ethers.getSigners();
    const ChakraBTC = await hre.ethers.getContractFactory("ChakraToken");
    const tokenInstance = await hre.upgrades.deployProxy(ChakraBTC, [
      await owner.getAddress(),
      await operator.getAddress(),
      name,
      symbol,
      decimals,
    ]);

    return { tokenInstance, deployer, owner, operator };
  }

  beforeEach(async function () {
    const { tokenInstance, deployer, owner, operator } = await deployERC20Fixture()

    // 1. Deploy Token Contract
    const tokenOwner = owner;
    const tokenOperator = operator;

    const decimals = 8; // Replace you token decimals

    const ChakraBTC = await hre.ethers.getContractFactory("ChakraToken");
   
    await tokenInstance.waitForDeployment();

    const tokenAddress = await tokenInstance.getAddress();
    chakraTokenObject = await tokenInstance.connect(owner) as ChakraToken;

    console.log("ChakraBTC contract deployed to: ", tokenAddress);
  });

  it("should have correct name, symbol, and decimals", async function () {
    expect(await chakraTokenObject.name()).to.equal("ChakraToken");
    expect(await chakraTokenObject.symbol()).to.equal("ckrBTC");
    expect(await chakraTokenObject.decimals()).to.equal(8);
  });

});
