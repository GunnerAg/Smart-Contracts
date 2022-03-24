// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./ERC20.sol";
import "./Limiter.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFTGame is ERC20, Ownable {
  
    uint256 private _totalSupply;
    address private _rewardAddress;
    address private _feeReceiveAddress;
    uint256 private _buyFee;
    uint256 private _sellFee;
    Limiter private _limiter;
    address private _lpCreatorAddress;
    bool private _isLockTransferForAntiBot;
    mapping(address => bool) _lpAddresses;

    // Contract events.
    event Deposit(address from, uint256 amount);
    event Withdraw(address to, uint256 amount);

    /**
     * @dev The contract constructor for NFTGame.sol
     * Sets the values of {ERC20.name} and {ERC20.symbol}.
     * Sets inital value of:
     * Fees: {_buyFee}, {_sellFee}.
     * AntiBotLock: true.
     * Addresses: {_rewardAddress}, {_feeReceiveAddress}, {_lpCreatorAddress}.
     * Limiter constructor params: {_maxBuy}, {_maxSell}, {_limitBuy}
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     */
    constructor() ERC20("NFTGame", "NFTG"){

        // Buy/Sell fee's.
        _buyFee = 20 * (10 ** (decimals() - 1));
        _sellFee = 20 * (10 ** (decimals() - 1));

        // Addresse's.
        _rewardAddress = address(0);
        _feeReceiveAddress = address(0);
        _isLockTransferForAntiBot = true;
        _lpCreatorAddress = address(0);

        // For the Limiter.sol constructor.
        _limiter = new Limiter(
            //Max Buy
            25000 * (10 ** decimals()),
            //Max Sell
            25000 * (10 ** decimals()),
            //Limit Buy
            5000000 * (10 ** decimals())
        );

        // Initalizing the total supply to deployer address.
        _mint(msg.sender, 100000000 * 10 ** decimals());

    }

    /**
     * @dev Sets the fee on purchasement.
     */
    function setBuyFee(uint256 fee) public onlyOwner {
        _buyFee = fee;
    }

    /**
     * @dev Sets the fee on token sell/exchange.
     */
    function setSellFee(uint256 _fee) public onlyOwner {
        _sellFee = _fee;
    }

    /**
     * @dev Returns the fees on buy and sell.
     *
     * @return buyFee && sellFee, The fees on purchasement and sell/exchange.
     */
    function getFees() external view returns(uint256 buyFee, uint256 sellFee) {
        return (_buyFee, _sellFee);
    }

    /**
     * @dev Sets the reward address.
     *
     * @param newRewardAddress The new reward address.
     */
    function setRewardAddress(address newRewardAddress) public onlyOwner {
        _rewardAddress = newRewardAddress;
    }
    
    /**
     * @dev Sets the fee reciver address.
     *
     * @param newFeeAddress The new fee reciver address.
     */
    function setFeeReceiveAddress(address newFeeAddress) public onlyOwner {
        require(newFeeAddress != address(0), "ERC20: Invalid receive address");
        _feeReceiveAddress = newFeeAddress;
    }

    /**
     * @dev Retrives the addresses of rewards, fees, and Liquidity Pool creator.
     *
     * @return reward && fee && lpCreator.
     */
    function getAddressesData() external view returns(
        address reward,
        address fee,
        address lpCreator
    ) {
        return (_rewardAddress, _feeReceiveAddress, _lpCreatorAddress);
    }

    /**
     * @dev Sets the maximum token amount buyable per transaction.
     *
     * @param max The new maximum token amount buyable per transaction.
     */
    function setMaxBuy(uint256 max) public onlyOwner {
        _limiter.setMaxBuyLimit(max);
    }

    /**
     * @dev Sets the maximum token amount sellable per transaction.
     *
     * @param max The new maximum token amount sellable per transaction.
     */
    function setMaxSell(uint256 max) public onlyOwner {
        _limiter.setMaxSellLimit(max);
    }

    /**
     * @dev Sets the limit of buyable tokens per address.
     *
     * @param _limit The new limit of buyable tokens per address.
     */
    function setLimitBuy(uint256 _limit) public onlyOwner {
        _limiter.setLimitBuy(_limit);
    }

    /**
     * @dev Return the data from the limiters.
     *
     * @return maxBuy && maxSell && totalBuy maximum buy and sell per transaction
     * and maximum token purchasable per wallet.
     */
    function getLimitData() external view returns(
        uint256 maxBuy, uint256 maxSell, uint256 totalBuy
    ) {
       return (_limiter.getMaxBuy(), _limiter.getMaxSell(), _limiter.getLimitBuy());
    }

    /**
     * @dev Returns the amount left to reach limit of buyable tokens for an address.
     *
     * @param _sender The address to check for.
     * @return The amount left to reach the buying limit of the address.
     */
    function getAddressTotalBuy(address _sender) public view virtual returns(int256) {
        return _limiter.getAddressTotalBuy(_sender);
    }

    /**
     * @dev Deposits token from msg.sender into the reward address.
     *
     * @param amount The amount of token to be deposited.
     */
    function deposit(uint256 amount) external virtual {
        require(_rewardAddress != address(0) && _msgSender() != address(0), "ERC20: Invalid address");
        transfer(_rewardAddress, amount);
        emit Deposit(_msgSender(), amount);
    }

    /**
     * @dev Withdraw token from the reward address to the recipient.
     *
     * @param recipient The recipient of the tokens.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(address recipient, uint256 amount) external virtual {
        require(_msgSender() != address(0) && _msgSender() == _rewardAddress, "NFTGame: Only the reward address can withdraw founds.");
        transfer(recipient, amount);
        emit Withdraw(_msgSender(), amount);
    }

    /**
     * @dev under testing.
    */
    function sellable(uint256 amount) internal view returns(bool){
      return _limiter.isValidSell(amount);
    }

    /**
     * @dev under testing.
    */
    function buyable(address recipient,uint256 amount) internal view returns(bool){
      return _limiter.isValidBuy(recipient, amount);
    }

    /**
     * @dev Overrides ERC20 transferFrom to add fees.
     * @notice See {IERC20-transferFrom}, requires valid allowance.
     *
     * @param sender The sender address.
     * @param recipient The recipient address.
     * @param amount The amount of tokens to transfer.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        require(!_isLockTransferForAntiBot || sender == _lpCreatorAddress, "NFTGame: Antibot revert");
        if (isAddressLP(recipient)) {
            // SELL
            uint256 _fee = 0;
            if (sender != _lpCreatorAddress) {
                require(sellable(amount), "NFTGame: Reached the Sell limit");
                _fee = calculateFee(amount, _sellFee);
            }
            return _transferFrom(sender, recipient, amount, _fee, _feeReceiveAddress);
        }
        return _transferFrom(sender, recipient, amount, 0, address(0));
    }

    /**
     * @dev Overrides ERC20 transfer.
     * @notice See {IERC20-transferFrom}.
     *
     * @param recipient The recipient address.
     * @param amount The amount of tokens to transfer.
     */
    function transfer(
        address recipient, 
        uint256 amount
    ) public virtual override returns (bool) {
        if (isAddressLP(_msgSender()) || isAddressLP(recipient)) {
            // BUY
            require(!_isLockTransferForAntiBot || recipient == _lpCreatorAddress, "NFTGame: Antibot revert");
            uint256 _fee = 0;
            if (recipient != _lpCreatorAddress) {
                require(buyable(recipient, amount), "NFTGame: Reached the Buy limit.");
                _fee = calculateFee(amount, _buyFee);
                if (isAddressLP(recipient)) {
                    _fee = calculateFee(amount, _sellFee);
                }
            }
            _transfer(_msgSender(), recipient, amount, _fee, _feeReceiveAddress);
            if (recipient != _lpCreatorAddress) {
                _limiter.onBuySuccess(recipient, amount);
            }
        } else {
            require(recipient != address(this), "NFTGame: Failed to transfer");
            
            _transfer(_msgSender(), recipient, amount, 0, address(0));
        }
        return true;
    }

    /**
     * @dev Estimates fee on transfer.
     *
     * @param amount The amount of tokens to transfer.
     * @param _fee The recipient address.
     */
    function calculateFee(uint256 amount, uint256 _fee) private view returns(uint256) {
        uint fraction = decimals() + 2;
        return amount * _fee / (10 ** fraction);
    }

    /**
     * @dev Sets the address that created the Liquidity Pool.
     *
     * @param _address The new value of the address.
     */
    function setLPCreatorAddress(address _address) external onlyOwner {
        _lpCreatorAddress = _address;
    }

    /**
     * @dev Turns the antibot transfer lock ON/OFF.
     *
     * @param enable Boolean value true = ON, false = OFF.
     */
    function setEnableAntibot(bool enable) external onlyOwner {
        _isLockTransferForAntiBot = enable;
    }

    /**
     * @dev Retrives antibot state and LP creator address.
     *
     * @return isEnable && lpCreator values of antibot state and Liquidity Pool creator address.
     */
    function getAntibotData() external view returns(bool isEnable, address lpCreator) {
        return (_isLockTransferForAntiBot, _lpCreatorAddress);
    }

    /**
     * @dev Adds a new address to the list of Liquidity Providers addresses.
     *
     * @param _addr The Liquidity Provider pool address.
     * @param enable State of the address, true = usable, false = not usable.
     */
    function setLPAddress(address _addr, bool enable) external onlyOwner {
        _lpAddresses[_addr] = enable;
    }

    /**
     * @dev Checks if and address is enabled in the list of Liquidity Providers.
     *
     * @param _addr The address to check.
     * @return boolean value, true if on the list, false if not.
     */
    function isAddressLP(address _addr) public view returns(bool) {
        return _lpAddresses[_addr];
    }
    
}