// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Limiter is Ownable {

    uint256 private _maxBuy;
    uint256 private _maxSell;
    uint256 private _limitBuy;

    mapping(address => uint256) private _totalBuy;
    
    /**
     * @dev The contract constructor for Limiter.sol
     * Sets inital value of:
     * @param maxBuy The maximum token amount buyable per transaction. 
     * @param maxSell The maximum token amount sellable per transaction.
     * @param limitBuy The limit of tokens buyable per address.
     */
    constructor(uint256 maxBuy, uint256 maxSell, uint256 limitBuy) {
        _maxBuy = maxBuy;
        _maxSell = maxSell;
        _limitBuy = limitBuy;
    }

    /**
     * @dev Retrives the maximum token amount buyable per transaction.
     *
     * @return The maximum token amount buyable per transaction.
     */
    function getMaxBuy() public view returns(uint256) {
        return _maxBuy;
    }

    /**
     * @dev Retrives the maximum token amount sellable per transaction.
     *
     * @return The maximum token amount sellable per transaction
     */
    function getMaxSell() public view returns(uint256) {
        return _maxSell;
    }

    /**
     * @dev Retrives the maximum token amount buyable per address.
     *
     * @return The maximum token amount buyable per address.
     */
    function getLimitBuy() public view returns(uint256) {
        return _limitBuy;
    }

    /**
     * @dev Checks before transfer is called on purchase,
     * if _limitBuy would be exceeded for the transaction.
     *
     * @return Boolean.
     */
    function isValidBuy(address _sender, uint256 _amount) public view returns(bool) {
        if (_amount > _maxBuy) {
            return false;
        }
        uint256 totalBuyOfAddress = _totalBuy[_sender];
        if (totalBuyOfAddress + _amount > _limitBuy) {
            return false;
        }
        return true;
    }
    
    /**
     * @dev Checks before transfer is called on sell,
     * if the amount would exceed _maxSell for the transaction.
     *
     * @return Boolean.
     */
    function isValidSell(uint256 _amount) public view returns(bool) {
        if (_amount > _maxSell) {
            return false;
        }
        return true;
    }

    /**
     * @dev Sets the maximum token amount buyable per transaction.
     *
     * @param maxBuy The new maximum token amount buyable per transaction.
     */
    function setMaxBuyLimit(uint256 maxBuy) public onlyOwner {
        _maxBuy = maxBuy;
    }

    /**
     * @dev Sets the maximum token amount sellable per transaction.
     *
     * @param maxSell The new maximum token amount sellable per transaction.
     */
    function setMaxSellLimit(uint256 maxSell) public onlyOwner {
        _maxSell = maxSell;
    }

    /**
     * @dev Sets the limit of buyable tokens per address.
     *
     * @param limitBuy The new limit of buyable tokens per address.
     */
    function setLimitBuy(uint256 limitBuy) public onlyOwner {
        _limitBuy = limitBuy;
    }

    /**
     * @dev Sets maximum buyable tokens per address after purchase success.
     *
     * @param _sender The address that bought the _amount.
     * @param _amount The amount bought by the _sender.
     */
    function onBuySuccess(address _sender, uint256 _amount) public onlyOwner {
        _totalBuy[_sender] += _amount;
    }

    /**
     * @dev Sets maximum sellable tokens per address after sell success.
     *
     * @param _sender The address that sold the _amount.
     * @param _amount The amount sold by the _sender.
     */
    function onSellSuccess(address _sender, uint256 _amount) public onlyOwner {
        uint256 value = _totalBuy[_sender];
        if (value < _amount) {
            _totalBuy[_sender] = 0;
        } else {
            _totalBuy[_sender] = (value - _amount);
        }
    }

    /**
     * @dev Returns the amount left to reach limit of buyable tokens for an address.
     *
     * @param _sender The address to check for.
     * @return The amount left to reach the buying limit of the address
     */
    function getAddressTotalBuy(address _sender) public view returns(int256) {
        return int256(_totalBuy[_sender]);
    }
}