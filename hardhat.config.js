require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.17",  
  networks: {
    hardhat: {
      forking: {
        url: "https://mainnet.infura.io/v3/89a0e3712f9246f487a488532cc0c53d",
        blockNumber: 20998274
      }
    }
  }
};
