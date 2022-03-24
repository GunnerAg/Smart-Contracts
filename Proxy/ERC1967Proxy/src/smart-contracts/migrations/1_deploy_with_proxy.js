/* eslint-disable no-undef */
const { deployProxy } = require('@openzeppelin/truffle-upgrades')

const WickeDrive = artifacts.require('./NFTGame.sol')
// const Proxy = artifacts.require('Proxy');

module.exports = async function (deployer) {
  await deployProxy(WickeDrive, [], { deployer })
}
