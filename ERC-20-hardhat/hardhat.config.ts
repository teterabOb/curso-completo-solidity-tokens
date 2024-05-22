import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY ?? "";
const providerApiKey = process.env.ALCHEMY_API_KEY || "";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: { 
    sepolia: {
      url:  `https://eth-sepolia.g.alchemy.com/v2/${providerApiKey}`,      
      accounts: [deployerPrivateKey],
    }
  }
};

export default config;
