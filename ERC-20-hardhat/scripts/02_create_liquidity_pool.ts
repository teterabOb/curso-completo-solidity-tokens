
// This script is used to create a liquidity pool for the ObserversToken and MockUSDC tokens on Uniswap.
async function deployLiquidityPool() {

    const V2Router02Address = "0x425141165d3DE9FEC831896C016617a52363b687"
    const FactoryAddress = "0xB7f907f7A9eBC822a80BD25E224be42Ce0A698A0"

    const { ethers } = require("hardhat");
    const fs = require("fs");

    const addresses = JSON.parse(fs.readFileSync('addresses.json', 'utf8'));
    console.log("Address of ObserversToken:", addresses.ObserversToken);
    console.log("Address of MockUSDC:", addresses.MockUSDC);

    const observersTokenAddress = addresses.ObserversToken;
    const mockUsdcAddress = addresses.MockUSDC;

    const uniswapFactoryAddress = "0xB7f907f7A9eBC822a80BD25E224be42Ce0A698A0";
    const factory = await ethers.getContractAt("IUniswapV2FactoryMock", uniswapFactoryAddress);

    // Obtener el addres del LP Token creado - el contraro es desplegado y verificado
    // en la misma tx
    const pairDeployed = await factory.getPair(observersTokenAddress, mockUsdcAddress);
    console.log("🚀 Pair / LP created at:", pairDeployed);  

    //const pairAddress = await factory.createPair(observersTokenAddress, mockUsdcAddress);
    //console.log("🚀 Pair / LP created at:", pairAddress);  
}

deployLiquidityPool()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("🛑 Error creating LP 🛑 :", error);
        process.exit(1);
    });