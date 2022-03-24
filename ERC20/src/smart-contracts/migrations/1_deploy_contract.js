/* eslint-disable no-undef */
const Wickedrive = artifacts.require('../contracts/NFTGame.sol')

module.exports = async function (deployer) {
  await deployer.deploy(NFTGame)
}
