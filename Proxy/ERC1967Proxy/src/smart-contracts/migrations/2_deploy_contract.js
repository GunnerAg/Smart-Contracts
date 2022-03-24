/* eslint-disable no-undef */
const myContract = artifacts.require('./NFTGame.sol')

module.exports = function (deployer) {
  deployer.deploy(myContract)
}
