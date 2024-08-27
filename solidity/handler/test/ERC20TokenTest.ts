import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { ChakraToken } from "../typechain";

import hre from "hardhat";
import { keccak256 } from "ethers";

describe("MyToken", function () {
  const name: string = "MyToken";
  const symbol: string = "MKT";
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

  it("Should upgrade to version 2", async () => {
    const { tokenInstance, owner } = await loadFixture(deployERC20Fixture);

    const instanceV2 =
      await hre.ethers.getContractFactory("ChakraTokenUpgrade");

    const upgraded = await hre.upgrades.upgradeProxy(
      await tokenInstance.getAddress(),
      instanceV2.connect(owner)
    );

    const upgraded_owner = await upgraded.owner();
    expect(upgraded_owner.toString()).to.equal(await owner.getAddress());

    expect(await upgraded.version()).to.equal("0.0.2");
  });

  it("Should initialize correctly", async function () {
    let utf8Encode = new TextEncoder();
    const { tokenInstance, owner, operator } =
      await loadFixture(deployERC20Fixture);

    const ownerAddress = await owner.getAddress();
    const operatorAddress = await operator.getAddress();
    let operatorRole = keccak256(utf8Encode.encode("OPERATOR_ROLE"));

    // Check that the relevant roles are correctly initialized
    expect(await tokenInstance.hasRole(operatorRole, operatorAddress)).to.equal(
      true
    );
    expect(await tokenInstance.is_operator(operatorAddress)).to.equal(true);
    expect(await tokenInstance.owner()).to.equal(ownerAddress);

    // Check that the token is properly initialized
    expect(await tokenInstance.balanceOf(ownerAddress)).to.equal(0);
    expect(await tokenInstance.balanceOf(operatorAddress)).to.equal(0);
    expect(await tokenInstance.name()).to.equal(name);
    expect(await tokenInstance.symbol()).to.equal(symbol);
    expect(await tokenInstance.decimals()).to.equal(decimals);
  });

  it("Should only owner can transfer ownership", async function () {
    const [a, b] = await hre.ethers.getSigners();
    const { tokenInstance, deployer, owner, operator } =
      await loadFixture(deployERC20Fixture);

    const aAddr = await a.getAddress();
    const bAddr = await b.getAddress();
    const ownerAddr = await owner.getAddress();

    await expect(
      ((await tokenInstance.connect(a)) as ChakraToken).transferOwnership(bAddr)
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );

    await expect(
      (
        (await tokenInstance.connect(deployer)) as ChakraToken
      ).transferOwnership(bAddr)
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );

    await expect(
      (
        (await tokenInstance.connect(operator)) as ChakraToken
      ).transferOwnership(bAddr)
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );

    const tx = (
      (await tokenInstance.connect(owner)) as ChakraToken
    ).transferOwnership(aAddr);
    await expect(tx)
      .emit(tokenInstance, "OwnershipTransferred")
      .withArgs(
        await owner.getAddress(), // oldOwner
        await a.getAddress() // newOwner
      );
    expect(await tokenInstance.owner()).to.equal(aAddr);
  });

  it("Should only owner can add and remove operator", async function () {
    let utf8Encode = new TextEncoder();
    let operatorRole = keccak256(utf8Encode.encode("OPERATOR_ROLE"));

    const [otherAccount, a] = await hre.ethers.getSigners();
    const otherAccountAddress = await otherAccount.getAddress();
    const aAddress = await a.getAddress();

    const { tokenInstance, owner, operator } =
      await loadFixture(deployERC20Fixture);

    // Owner add operator
    await (tokenInstance.connect(owner) as ChakraToken).add_operator(
      otherAccountAddress
    );
    expect(
      await tokenInstance.hasRole(operatorRole, otherAccountAddress)
    ).to.equal(true);
    expect(await tokenInstance.is_operator(otherAccountAddress)).to.equal(true);

    // Owner remove operator
    await (tokenInstance.connect(owner) as ChakraToken).remove_operator(
      otherAccountAddress
    );
    expect(
      await tokenInstance.hasRole(operatorRole, otherAccountAddress)
    ).to.equal(false);
    expect(await tokenInstance.is_operator(otherAccountAddress)).to.equal(
      false
    );

    // Other account cannot add or remove operator should revert
    await expect(
      (tokenInstance.connect(otherAccount) as ChakraToken).add_operator(
        otherAccount
      )
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );
    await expect(
      (tokenInstance.connect(otherAccount) as ChakraToken).remove_operator(
        otherAccount
      )
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );
    await expect(
      (tokenInstance.connect(operator) as ChakraToken).add_operator(
        otherAccount
      )
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );
    await expect(
      (tokenInstance.connect(operator) as ChakraToken).remove_operator(
        otherAccount
      )
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "OwnableUnauthorizedAccount"
    );
  });

  it("Should only operator to operate mint and burn", async function () {
    const { tokenInstance, deployer, owner, operator } =
      await loadFixture(deployERC20Fixture);

    const [user] = await hre.ethers.getSigners();
    const userAddress = await user.getAddress();

    // Check that deployer and owner can't do mint and burn
    await expect(
      (tokenInstance.connect(deployer) as ChakraToken).mint_to(userAddress, 100)
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "AccessControlUnauthorizedAccount"
    );
    await expect(
      (tokenInstance.connect(deployer) as ChakraToken).burn_from(
        userAddress,
        100
      )
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "AccessControlUnauthorizedAccount"
    );
    await expect(
      (tokenInstance.connect(owner) as ChakraToken).mint_to(userAddress, 100)
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "AccessControlUnauthorizedAccount"
    );
    await expect(
      (tokenInstance.connect(owner) as ChakraToken).burn_from(userAddress, 100)
    ).to.be.revertedWithCustomError(
      tokenInstance,
      "AccessControlUnauthorizedAccount"
    );

    // Check minter and burner works
    await (tokenInstance.connect(operator) as ChakraToken).mint_to(
      userAddress,
      100
    );
    expect(await tokenInstance.balanceOf(userAddress)).to.equal(100);
    await (tokenInstance.connect(operator) as ChakraToken).burn_from(
      userAddress,
      50
    );
    expect(await tokenInstance.balanceOf(userAddress)).to.equal(50);
  });
});
