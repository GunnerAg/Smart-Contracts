//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NFTGame.sol";

contract Test {
  function testInitialBalanceUsingDeployedContract() public {
    NFTGame nftg = WickeDrive(DeployedAddresses.NFTGame());
    uint expected = nftg.totalSupply();
    Assert.equal(nftg.balanceOf(tx.origin), expected, "Owner should have 10000 NFTGame initially");
  }
}
