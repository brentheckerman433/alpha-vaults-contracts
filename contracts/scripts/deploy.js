const { ethers } = require("hardhat");

async function main() {
  // Deploy Vaults
  const CryoVault = await ethers.getContractFactory("CryoVault");
  const cryoVault = await CryoVault.deploy(/* asset, name, symbol */);
  await cryoVault.deployed();

  const CoolVault = await ethers.getContractFactory("CoolVault");
  const coolVault = await CoolVault.deploy(/* asset, name, symbol */);
  await coolVault.deployed();

  const HeatVault = await ethers.getContractFactory("HeatVault");
  const heatVault = await HeatVault.deploy(/* asset, name, symbol */);
  await heatVault.deployed();

  const IRSReserveVault = await ethers.getContractFactory("IRSReserveVault");
  const irsReserveVault = await IRSReserveVault.deploy(/* asset, name, symbol */);
  await irsReserveVault.deployed();

  // Deploy VaultRouter with vault addresses
  const VaultRouter = await ethers.getContractFactory("VaultRouter");
  const vaultRouter = await VaultRouter.deploy(
    cryoVault.address,
    coolVault.address,
    heatVault.address
  );
  await vaultRouter.deployed();

  // Deploy DFDToken with router and IRSReserve
  const DFDToken = await ethers.getContractFactory("DFDToken");
  const dfdToken = await DFDToken.deploy(vaultRouter.address, irsReserveVault.address);
  await dfdToken.deployed();

  // Deploy RebeccaIdentity with Brent’s wallet address
  const RebeccaIdentity = await ethers.getContractFactory("RebeccaIdentity");
  const rebecca = await RebeccaIdentity.deploy("0xYourWalletHere");
  await rebecca.deployed();

  // Deploy OperatorRelay
  const OperatorRelay = await ethers.getContractFactory("OperatorRelay");
  const operator = await OperatorRelay.deploy();
  await operator.deployed();

  // Output addresses
  console.log("CryoVault:", cryoVault.address);
  console.log("CoolVault:", coolVault.address);
  console.log("HeatVault:", heatVault.address);
  console.log("IRSReserveVault:", irsReserveVault.address);
  console.log("VaultRouter:", vaultRouter.address);
  console.log("DFDToken:", dfdToken.address);
  console.log("RebeccaIdentity:", rebecca.address);
  console.log("OperatorRelay:", operator.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});Automate deployment of full Vault Smart suite (Cryo / Cool / Heat / IRS / Router / DFD / Rebecca / Operator)
