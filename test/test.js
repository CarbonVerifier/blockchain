const fs = require('fs');
var contracts = ['CdbBrb', 'Klabin', 'FiiBrb', 'Google', 'Alpargatas', 'LcaBrb'];
var addresses = [];

contracts.forEach((contract_name) => {
  var Contract = artifacts.require(contract_name);
  contract(contract_name, (accounts) => {
    let Instance = undefined;
    it(`${contract_name} should be deployed`, async () => {
      Instance = await Contract.deployed();
      assert.notEqual(Instance, undefined, 'Contract not deployed');
    });
    
    it(`can mint ${contract_name}`, async () => {
      const testValue = 69;
      
      const AccountInitialBalance = await Instance.balanceOf.call(accounts[0], 0);
      await Instance.mint(accounts[0], testValue);
          const AccountUpdatedBalance = await Instance.balanceOf.call(accounts[0], 0);
          
          assert.equal(AccountUpdatedBalance - AccountInitialBalance, testValue, 'Minting failed');
        });
        
        it(`has URI for ${contract_name}`, async () => {
          const uri = await Instance.uri.call(0);
          // start with https://ipfs.io/
          assert.equal(uri.substring(0, 16), 'https://ipfs.io/', 'URI not set');
          
        });
        it(`get deployed contract address ${contract_name}`, async () => {
          const contractAddress = await Instance.address;
          addresses.push(contractAddress);
          console.log(addresses)        });
      });
    });