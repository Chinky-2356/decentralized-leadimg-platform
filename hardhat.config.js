require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
        details: {
          yul: false
        }
      },
      viaIR: false
    }
  },
  networks: {
    // Core Testnet 2 configuration
    core_testnet2: {
      url: process.env.CORE_TESTNET2_RPC_URL || "https://rpc.test2.btcs.network",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 1115,
      gasPrice: 20000000000, // 20 gwei
      gas: 8000000, // 8M gas limit
      timeout: 60000, // 60 seconds
      confirmations: 1
    },
    // Core Mainnet configuration (for future use)
    core_mainnet: {
      url: process.env.CORE_MAINNET_RPC_URL || "https://rpc.coredao.org",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 1116,
      gasPrice: 20000000000, // 20 gwei
      gas: 8000000,
      timeout: 60000,
      confirmations: 2
    },
    // Local development network
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
      gas: 12000000,
      gasPrice: 20000000000,
      timeout: 60000
    },
    // Hardhat network for testing
    hardhat: {
      chainId: 31337,
      gas: 12000000,
      gasPrice: 20000000000,
      blockGasLimit: 12000000,
      accounts: {
        count: 20,
        accountsBalance: "10000000000000000000000" // 10000 ETH
      },
      mining: {
        auto: true,
        interval: 0
      }
    },
    // Additional testnets for development
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || "https://sepolia.infura.io/v3/" + (process.env.INFURA_PROJECT_ID || ""),
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 11155111,
      gasPrice: 20000000000,
      gas: 8000000
    },
    goerli: {
      url: process.env.GOERLI_RPC_URL || "https://goerli.infura.io/v3/" + (process.env.INFURA_PROJECT_ID || ""),
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 5,
      gasPrice: 20000000000,
      gas: 8000000
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
    deploy: "./scripts"
  },
  mocha: {
    timeout: 120000, // 2 minutes
    retries: 2
  },
  etherscan: {
    // Add API key for contract verification
    apiKey: {
      core_testnet2: process.env.ETHERSCAN_API_KEY || "",
      core_mainnet: process.env.ETHERSCAN_API_KEY || "",
      sepolia: process.env.ETHERSCAN_API_KEY || "",
      goerli: process.env.ETHERSCAN_API_KEY || ""
    },
    customChains: [
      {
        network: "core_testnet2",
        chainId: 1115,
        urls: {
          apiURL: "https://api.test2.btcs.network/api",
          browserURL: "https://scan.test2.btcs.network"
        }
      },
      {
        network: "core_mainnet",
        chainId: 1116,
        urls: {
          apiURL: "https://openapi.coredao.org/api",
          browserURL: "https://scan.coredao.org"
        }
      }
    ]
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    coinmarketcap: process.env.COINMARKETCAP_API_KEY || ""
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true
  },
  abiExporter: {
    path: "./abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    spacing: 2,
    pretty: true
  },
  typechain: {
    outDir: "typechain-types",
    target: "ethers-v5"
  },
  defaultNetwork: "hardhat"
};
