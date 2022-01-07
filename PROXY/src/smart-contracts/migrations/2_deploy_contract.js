/* eslint-disable no-undef */
const myContract = artifacts.require('./WickeDrive.sol')

module.exports = function (deployer) {
  deployer.deploy(myContract)
}
