/* eslint-disable no-undef */
require('@nomiclabs/hardhat-waffle')
require('@nomiclabs/hardhat-ethers')
require('@openzeppelin/hardhat-upgrades')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: 'rinkeby',
  networks: {
    rinkeby: {
      url: 'https://rinkeby.infura.io/v3/c91b3318090544299c446a05dd64bc94',
      accounts: ['0x85fb96d1b1766621c469d7b3dba2638a9dfa9f9ba7d7ef73cc6d3ed3901dcfa6']
    }
  },
  solidity: '0.8.4'
}
