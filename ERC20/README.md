# WickeDrive:  
### WickeDrive NFT Game Contract depoloyer script, it holds all the required helpers and settings for the contract deployment.


## Limiter.sol
**A contract that limits values for purchase and sells on Liquidity Providers.**
### Variables:
  * _maxBuy
  * _maxSell
  * _limitBuy
  * _totalBuy

### Constructor
  Takes the following arguments to build the instance.
  * maxBuy: The maximum token amount buyable per transaction.
  * maxSell: The maximum token amount sellable per transaction.
  * limitBuy: The limit of tokens buyable per address.

### Functions:
  1. getMaxBuy.
      * Description: Retrives the maximum token amount buyable per transaction.
      * Parameters: none.
      * Returns: uint256 _maxBuy, The maximum token amount buyable per transaction.

  2. getMaxSell.  
      * Description: Retrives the maximum token amount sellable per transaction.
      * Parameters: none.
      * Returns: uint256 _maxSell, The maximum token amount sellable per transaction.

  3. getLimitBuy.  
      * Description: Retrives the maximum token amount buyable per address.
      * Parameters: none.
      * Returns: uint256 _limitBuy, The maximum token amount buyable per address.

  4. isValidBuy.  
      * Description: Checks before transfer is called on purchase, if _limitBuy would be exceeded for the transaction.
      * Parameters: none.
      * Returns: boolean Represents if the purchase is valid or not.

  5. isValidSell.  
      * Description: Checks before transfer is called on sell, if the amount would exceed _maxSell for the transaction.
      * Parameters:
          * uint256 _amount, the amount to be sold. 
      * Returns: boolean. Represents if the sell is valid or not. 

  6. setMaxBuyLimit.  
      * Description: Sets the maximum token amount buyable per transaction.  
      * Parameters:  
          * uint256 maxBuy, The maximum token amount buyable per transaction.  
      * Returns: void.  

  7. setMaxSellLimit.  
      * Description: Sets the maximum token amount sellable per transaction.  
      * Parameters:  
          * uint256 maxSell, The new maximum token amount sellable per transaction.  
      * Returns: void.  

  8. setLimitBuy.  
      * Description: Sets the limit of buyable tokens per address.  
      * Parameters:  
          * uint256 limitBuy, The new limit of buyable tokens per address.  
      * Returns: void.  

  9. onBuySuccess.  
      * Description: Sets maximum buyable tokens per address after purchase success.  
      * Parameters:  
          * address _sender, The address that bought the _amount.  
          * uint256 _amount, The amount bought by the _sender.  
      * Returns: void.  

  10. onSellSuccess.  
      * Description: Sets maximum sellable tokens per address after sell success.  
      * Parameters:  
          * address _sender, The address that sold the _amount.  
          * uint256 _amount, The amount sold by the _sender.  
      * Returns: void.  

  11. getAddressTotalBuy.  
      * Description: Returns the amount left to reach limit of buyable tokens for an address.  
      * Parameters:  
          * address _sender, The address to check for.  
      * Returns: int256 _totalBuy[_sender], The amount left to reach the buying limit of the address.  


## ERC20.sol
**A ERC20 standard contract with modifications on transfer and transferFrom functions.**
**For details please see the EIP-20:Token Standard @ https://eips.ethereum.org/EIPS/eip-20.**
### Variables:
  * _balances
  * _allowances
  * _totalSupply
  * _name
  * _symbol
  * _totalBuy

### Events:
  * Transfer(account, address, amount)
  * Approval(owner, spender, amount)

### Constructor
  Takes the following arguments to build the instance.
  * _name: The Contract name, unchangable.
  * _symbol: The Contract symbol, unchangable.

### Functions:
  1. name.
      * Description: Retrives the Contract name.
      * Parameters: none.
      * Returns: string _name, The Contract name.

  2. symbol.
      * Description: Retrives the Contract symbol.
      * Parameters: none.
      * Returns: string _symbol, The Contract symbol.

  3. decimals.  
      * Description: Retrives the Contract number of decimals, default value is 18.
      * Parameters: none.
      * Returns: 18.

  4. totalSupply.  
      * Description: Returns the total amount of tokens minted.
      * Parameters: none.
      * Returns: uint256 _totalSupply.

  5. balanceOf.  
      * Description: Checks the token balance of a given address.  
      * Parameters:  
          * address account, the account to be checked.  
      * Returns: uint256 _balances[account].  

  6. transfer.  
      * Description: Transfers the amount of tokens from msg.sender to recipient.  
      * Parameters:  
          * address recipient, The address that recives the tokens.  
          * uint256 amount, The amount of tokens transfered to the recipient.  
      * Returns: boolean. Represents if the transaction succeded or failed.  

  7. allowance.  
      * Description: Returns the amount of tokens spender is allow to spend on behalf of the owner.  
      * Parameters:  
          * address owner, The owner of the tokens.  
          * address spender, The spender of the tokens.  
      * Returns: _allowances[owner][spender].  

  8. approve.  
      * Description: Sets the amount of tokens spender is allow to spend on behalf of the owner.  
      * Parameters:  
          * address spender, The spender of the tokens.  
          * uint256 amount, The new amount allowed to spend.  
      * Returns: _approve(_msgSender(), spender, amount);  

  9. transferFrom.  
      * Description: Transfers the amount of tokens from the sender to the recipient.  
      * Parameters:  
          * address sender, The address that sends the amount.  
          * address recipient, The address that recives amount.  
          * uint256 amount, The amount sent.  
      * Returns: _transferFrom(sender, recipient, amount, 0, address(0)).  

  10. _transferFrom.  
      * Description: Transfers the amount of tokens from the sender to the recipient with fee charge.  
      * Parameters:  
          * address sender, The address that sends the amount.  
          * address recipient, The address that recives the amount.  
          * uint256 amount, The amount sent.  
          * uint256 fee, The fee charge.  
          * address feeReceiveAddress, The address that recives the fee.  
      * Returns: _transfer(sender, recipient, amount, fee, feeReceiveAddress); 

  11. increaseAllowance.  
      * Description: Increases the allowance of spender on behalf of msg.sender (as owner).  
      * Parameters:  
          * address spender, The spender of the tokens.  
          * address addedValue, The added value to the current allowance.  
      * Returns: boolean. Represents if the _approve succeded or failed.  

  12. decreaseAllowance.  
      * Description: Decreases the allowance of spender on behalf of msg.sender (as owner).  
      * Parameters:  
          * address spender, The spender of the tokens.  
          * address subtractedValue, The substracted value to the current allowance.  
      * Returns: boolean. Represents if the _approve succeded or failed.  

  13. _transfer.  
      * Description: Transfers the amount of tokens from the sender to the recipient with fee charge.  
      * Parameters:  
          * address sender, The address that sends the amount.  
          * address recipient, The address that recives the amount.  
          * uint256 amount, The amount sent.  
          * uint256 fee, The fee charge.  
          * address feeReceiveAddress, The address that recives the fee.  
      * Returns: boolean. Represents if the transfer succeded or failed.  

  14. _mint.  
      * Description: Mints(creates) the amount of tokens to the account.  
      * Parameters:  
          * address account, The account that recives the tokens.  
          * uint256 amount, The amount of tokens created.  
      * Returns: Transfer event.  

  14. _burn.  
      * Description: Burns(destroys) the amount of tokens from the account.  
      * Parameters:  
          * address account, The account that burns the tokens.  
          * uint256 amount, The amount of tokens destroyed.  
      * Returns: Transfer event.  

  15. _approve.  
      * Description: Sets the amount of tokens spender is allow to spend on behalf of the owner.  
      * Parameters:  
          * address owner, The owner of the tokens.  
          * address spender, The spender of the tokens.  
          * uint256 amount, The new amount allowed to spend.  
      * Returns: Approval event.  

  16. _beforeTokenTransfer.  
      * Description: Hook to add logic before transfering tokens.  
      * Parameters:  
          * address from, The address that sends the amount.  
          * address to, The address that recives the amount.  
          * uint256 amount, The new amount sent.  
      * Returns: void.  

  17. _afterTokenTransfer.  
      * Description: Hook to add logic after transfering tokens.  
      * Parameters:  
          * address from, The address that sends the amount.  
          * address to, The address that recives the amount.  
          * uint256 amount, The new amount sent.  
      * Returns: void.  


## Wickedrive.sol
**The main game logic contract.**
### Variables:  
  * _totalSupply  
  * _name  
  * _symbol  
  * _rewardAddress  
  * _feeReceiveAddress  
  * _buyFee  
  * _sellFee  
  * _limiter  
  * _lpCreatorAddress  
  * _isLockTransferForAntiBot  
  * _lpAddresses  

### Events:  
  * Deposit(address from, amount)  
  * Withdraw(address to, amount)  

### Constructor  
  Takes no arguments, creates an instance.  
  * _buyFee: The intial purchase fee 20.  
  * _sellFee: The inital sell fee 20.  
  * _rewardAddress: Address for rewards and stake, Initalized to the zero address.  
  * _feeReceiveAddress:  Address for fee's, Initalized to the zero address.  
  * _isLockTransferForAntiBot: Transfer's Lock, Initalized to true.  
  * _lpCreatorAddress: Address that creates the liquidity pool, Initalized to the zero address.  
  * _limiter: Instance of Limiter.sol, Initialized with (25000, 25000, 5000000).  
  * _mint(): Mints 100000000 to contract deployer address.  

### Functions:  
  1. setBuyFee.  
      * Description: Sets the fee on purchasement.  
      * Parameters:  
          * uint256 fee, the fee amount.  
      * Returns: void.  

  2. setSellFee.  
      * Description: Sets the fee on sell.  
      * Parameters:  
          * uint256 _fee, the fee amount.  
      * Returns: void.  

  3. getFees.  
      * Description: Returns the fees on buy and sell.  
      * Parameters: none.  
      * Returns:  
          * uint256 buyFee, the buy fee amount.  
          * uint256 sellFee, the sell fee amount.  

  4. setRewardAddress.  
      * Description: Sets the reward address.  
      * Parameters:  
          * address newRewardAddress, The new reward address.  
      * Returns: void.  

  5. setFeeReceiveAddress.  
      * Description: Sets the fee reciver address.  
      * Parameters:  
          * address newFeeAddress, The new fee reciver address.  
      * Returns: void.  

  6. getAddressesData.  
      * Description: Retrives the addresses of rewards, fees, and Liquidity Pool creator.  
      * Parameters: none.  
      * Returns:  
          * uint256 _rewardAddress, The address of rewards.  
          * uint256 _feeReceiveAddress, The address for fee's.  
          * uint256 _lpCreatorAddress, The address that created the liquidity pool.  

  7. setMaxBuy.  
      * Description: Sets the maximum token amount buyable per transaction.  
      * Parameters:  
          * uint256 max, The new maximum token amount buyable per transaction.  
      * Returns: _limiter.setMaxBuyLimit(max).  

  8. setMaxSell.  
      * Description: Sets the maximum token amount sellable per transaction.  
      * Parameters:  
          * uint256 max, The new maximum token amount sellable per transaction.  
      * Returns: _limiter.setMaxSellLimit(max).  

  9. setLimitBuy.  
      * Description: Sets the limit of buyable tokens per address.  
      * Parameters:  
          * uint256 _limit, The new limit of buyable tokens per address.  
      * Returns: _limiter.setLimitBuy(_limit).  

  10. getLimitData.  
      * Description: Return the data from the limiters.  
      * Parameters: none.  
      * Returns:  
          * _limiter.getMaxBuy().  
          * _limiter.getMaxSell().  
          * _limiter.getLimitBuy().  

  11. getAddressTotalBuy.  
      * Description: Returns the amount left to reach limit of buyable tokens for an address.  
      * Parameters:  
          * address _sender, The address to check for.  
      * Returns: _limiter.getAddressTotalBuy(_sender).  

  12. deposit.  
      * Description: Deposits token from msg.sender into the reward address.  
      * Parameters:  
          * uint256 amount, The amount of token to be deposited.  
      * Returns: transfer(_rewardAddress, amount), Deposit event.  

  13. withdraw.  
      * Description: Withdraw token from the reward address to the recipient.  
      * Parameters:  
          * address sender, The recipient of the tokens.  
          * uint256 amount, The amount of tokens to withdraw.  
      * Returns: transfer(recipient, amount), Withdraw event.  

  14. transferFrom.  
      * Description: Overrides ERC20 transferFrom to add fees.  
      * Parameters:  
          * address sender, The sender address.  
          * address recipient, The recipient address.  
          * uint256 amount, The amount of tokens to transfer.  
      * Returns: _transferFrom(sender, recipient, amount, _fee, _feeReceiveAddress).  

  14. transfer.  
      * Description: Overrides ERC20 transfer.  
      * Parameters:  
          * address recipient, The recipient address.  
          * uint256 amount, The amount of tokens to transfer.  
      * Returns: _transfer(_msgSender(), recipient, amount, _fee, _feeReceiveAddress).  

  15. calculateFee.  
      * Description: Estimates fee on transfer.  
      * Parameters:  
          * address owner, The amount of tokens to transfer.  
          * uint256 _fee, The recipient address.  
      * Returns: uint256 with the fee amount.  

  16. setLPCreatorAddress.  
      * Description: Sets the address that created the Liquidity Pool.  
      * Parameters:  
          * address _address, The new value of the address.  
      * Returns: void.  

  17. setEnableAntibot.  
      * Description: Turns the antibot transfer lock ON/OFF.  
      * Parameters:  
          * boolean enable. Boolean value true = ON, false = OFF.  
      * Returns: void.  

  18. getAntibotData.  
      * Description: Retrives antibot state and LP creator address.  
      * Parameters: none.  
      * Returns:  
          * boolean isEnable. Value of antibot state.  
          * address lpCreator. Liquidity Pool creator address.  

  19. setLPAddress.  
      * Description: Adds a new address to the list of Liquidity Providers addresses.  
      * Parameters:  
          * address _addr, The Liquidity Provider pool address.  
          * boolean enable, State of the address, true = usable, false = not usable.  
      * Returns: void.  

  20. isAddressLP.  
      * Description: Checks if and address is enabled in the list of Liquidity Providers.  
      * Parameters:  
          * address _addr, The address to check.  
      * Returns: boolean _lpAddresses[_addr]. True if on the list, false if not.  