// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");


async function deployToken() {
  const [deployer] = await ethers.getSigners()

  console.log("Deploying token contract with the account:", deployer.address)
  console.log("Account balance: ", (await deployer.getBalance()).toString())

  const Token = await ethers.getContractFactory("BEP40Token")
  const token = await Token.deploy();

  console.log("Token address:", token.address)
}


async function deployPool() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying pool contract with the account:", deployer.address)
  console.log("Account balance: ", (await deployer.getBalance()).toString())

  const Pool = await ethers.getContractFactory("Pool")
  const owner = ""
  const stablecoinContract = "0x3Aa847B2008E326f8f453289384A4FF0AB2412ca"
  const pool = await Pool.deploy(owner, stablecoinContract)

  console.log("Pool address:", pool.address)
}

deployPool()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
