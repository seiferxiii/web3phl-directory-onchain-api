const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Web3PHL Directory NFT Test Cases", () => {
    let deployer, web3PhlNFT

    before(async()=>{
        [deployer] = await ethers.getSigners();
        console.log("Deploying contracts with the account:", deployer.address);
        console.log("Account balance:", (await deployer.getBalance()).toString());

        const Web3PhlDirectoryNFT = await ethers.getContractFactory("Web3PhlDirectoryNFT");
        web3PhlNFT = await Web3PhlDirectoryNFT.deploy();
        await web3PhlNFT.deployed()

        console.log("Web3PhlDirectoryNFT address:", web3PhlNFT.address);
    })

    it("Should be able to check initial supply", async() => {
        const totalSupply = await web3PhlNFT.totalSupply()
        expect(totalSupply).is.eq(0)
    })
})