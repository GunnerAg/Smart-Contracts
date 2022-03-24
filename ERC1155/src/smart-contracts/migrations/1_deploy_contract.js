/* eslint-disable no-undef */
const MintClubToken = artifacts.require('./MintClubToken.sol')
const BaseContract = artifacts.require('./BaseContract.sol')
const MintClubBond = artifacts.require('./MintClubToken.sol')

module.exports = async function (deployer, network, accounts) {
  process.env.NETWORK_ID = network;
  // deployment steps
  await deployer.deploy(MintClubToken)
  await deployer.deploy(BaseContract)
  const MintClubTokenInstance = await MintClubToken.deployed()
  const BaseContractInstance = await BaseContract.deployed()
  await deployer.deploy(MintClubBond, BaseContractInstance.address, MintClubTokenInstance.address);
}
