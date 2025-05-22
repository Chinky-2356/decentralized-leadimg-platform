{
  "name": "decentralized-leading-platform",
  "version": "1.0.0",
  "description": "A decentralized platform that revolutionizes digital interactions through blockchain technology",
  "main": "index.js",
  "scripts": {
    "compile": "npx hardhat compile",
    "test": "npx hardhat test",
    "deploy": "npx hardhat run scripts/deploy.js --network core_testnet2",
    "deploy:local": "npx hardhat run scripts/deploy.js --network localhost",
    "node": "npx hardhat node"
  },
  "keywords": [
    "blockchain",
    "solidity",
    "hardhat",
    "decentralized",
    "smart-contracts",
    "web3"
  ],
  "author": "Your Name",
  "license": "MIT",
  "devDependencies": {
    "@nomicfoundation/hardhat-toolbox": "^4.0.0",
    "hardhat": "^2.19.0"
  },
  "dependencies": {
    "@openzeppelin/contracts": "^4.9.0",
    "dotenv": "^16.3.1"
  }
}
