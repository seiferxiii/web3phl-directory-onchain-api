require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      forking: {
        url: process.env.POLYGON_RPC,
        blockNumber: 28367911
      }
    },
    polygonmainnet: {
      url: process.env.POLYGON_RPC,
      accounts: [`${process.env.DEPLOYER_PRIVATEKEY}`],
      gasPrice: 35000000000,
    },
    bscscantestnet: {
      url: process.env.BSC_TESTNET_RPC,
      accounts: [`${process.env.DEPLOYER_PRIVATEKEY}`],
    }
  },
  etherscan: {
    apiKey: {
      polygon: `${process.env.POLYGONSCAN_APIKEY}`,
      bscTestnet: `${process.env.BSCSCAN_APIKEY}`
    }
  },
};
