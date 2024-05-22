
const V2Router02Address = "0x425141165d3DE9FEC831896C016617a52363b687"
const FactoryAddress = "0xB7f907f7A9eBC822a80BD25E224be42Ce0A698A0"

async function deployToken() {
  const { ethers } = require("hardhat");
  const fs = require("fs");
  
  const [deployer] = await ethers.getSigners();

  const ObserversToken = await ethers.getContractFactory("ObserversToken");
  const MockUsdcToken = await ethers.getContractFactory("MockUSDC");

  const observersToken = await ObserversToken.deploy(deployer.address);
  const mockUsdcToken = await MockUsdcToken.deploy(deployer.address);

  await observersToken.waitForDeployment();
  const tokenAddress = await observersToken.getAddress();
  console.log("🚀 ObserversToken deployed to:", tokenAddress);

  await mockUsdcToken.waitForDeployment();
  const usdcAddress = await mockUsdcToken.getAddress();
  console.log("🚀 MockUSDC deployed to:", usdcAddress);

  let addresses: { [key: string]: string } = {};

  // Validamos que el archivo exista
  if (fs.existsSync("addresses.json")) {
    // Limpiamos el archivo 
    fs.writeFileSync("addresses.json", JSON.stringify({}, null, 2));
    addresses = JSON.parse(fs.readFileSync("addresses.json", "utf-8"));
  }

  addresses.ObserversToken = tokenAddress;
  addresses.MockUSDC = usdcAddress;

  fs.writeFileSync("addresses.json", JSON.stringify(addresses, null, 2));
}

deployToken()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("🛑 Error deploying tokens 🛑 :", error);
    process.exit(1);
  });