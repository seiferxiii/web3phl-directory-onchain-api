const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Web3PHL Directory NFT Test Cases", () => {
    let deployer, web3PhlNFT, user1

    before(async()=>{
        [deployer, user1] = await ethers.getSigners();
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

    it("Should be able to mint nft", async() => {
        await web3PhlNFT.connect(user1).safeMint("DvCode Technologies Inc.","DvCode Technologies Inc. is an IT solutions company specializing in software development leveraging on blockchain smart contracts, digital wallets, and cyber-security; game app development; network infrastructure building and web 3.0 development. Our main goal is to help our clients make use of the modern technology in their every lives that will be fun, easy-to-use, cost-effective and convenient.","dvcode.tech",["company","gaming","defi","nft"])
        const balanceOfUser1 = await web3PhlNFT.balanceOf(user1.address)
        expect(balanceOfUser1).is.eq(1)
    })
})