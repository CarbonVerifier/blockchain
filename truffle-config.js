require('dotenv').config({path: '.env'});
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    alfajores: {
      networkCheckTimeout: 60000,
      provider: function() {
        return new HDWalletProvider(
          process.env.MNEMONIC_PHRASE, 
          'https://alfajores-forno.celo-testnet.org'
        );
      },
      network_id: 44787,
    },
  },
  compilers: {
    solc: {
      version: "0.8.9",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};
