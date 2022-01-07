pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NftGame is ERC20 {
  constructor() ERC20('MyGame', 'CGNFT'){
    _mint(msg.sender, 100000000);
  }
}