import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "hardhat-deploy";
import "@nomiclabs/hardhat-etherscan";
import { HardhatUserConfig } from "hardhat/config";
import networks from "./networks";
import dotenv from "dotenv";
dotenv.config();

const ALCHEMY_API_KEY = process.env.RINKEBY_RPC;
const RINKEBY_PRIVATE_KEY = process.env.DEV_MNEMONIC;

/**
 * Go to https://hardhat.org/config/ to learn more
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 60,
    coinmarketcap: process.env.COIN_MARKET_CAP,
  },
  networks: {
    rinkeby: {
      url: ALCHEMY_API_KEY,
      accounts: [`${RINKEBY_PRIVATE_KEY}`]
    },
    hardhat: {
    }
  },
  namedAccounts: {
    deployer: 0,
    purchaser: 0,
  },
  solidity: {
    version: "0.8.6",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100,
      },
    },
  },
};

export default config;
