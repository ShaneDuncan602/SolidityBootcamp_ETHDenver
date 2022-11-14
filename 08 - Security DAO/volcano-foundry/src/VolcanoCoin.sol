// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "openzeppelin-contracts/access/Ownable.sol";

/**
 * @title VolcanoCoin
 * @author @ShaneDuncan602
 * @notice Lesson 4 of ETHDenver
 */
contract VolcanoCoin is Ownable {
    uint256 public totalSupply = 10000;
    mapping(address => uint256) public balances;
    struct Payment {
        address recipientAddress;
        uint256 amount;
    }
    Payment payment;
    mapping(address => Payment[]) public payments;

    error NotEnoughFunds(uint256 requestedToTransfer, uint256 available);

    event IncreaseTotalSupply(uint256 newSupply);
    event Transfer(uint256 amount, address recipient);

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function isOwner() internal view returns (bool) {
        return owner() == msg.sender;
    }

    // Getter for individual balance
    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }

    /// Getter for totalSupply
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    /// Record new payment records
    function recordPayment(
        address _payer,
        address _receiver,
        uint256 amount
    ) private {
        payment = Payment(_receiver, amount);
        payments[_payer].push(payment);
    }

    /// Getter for totalSupply
    function getPayments(address _payer)
        public
        view
        returns (Payment[] memory)
    {
        return payments[_payer];
    }

    /// Increase total supply by 1000
    function increaseTotalSupply() public onlyOwner {
        totalSupply += 1000;
        emit IncreaseTotalSupply(totalSupply);
    }

    /// Transfer tokens
    function transferToken(address toAddress, uint256 amount) public {
        if (balances[msg.sender] > 0) {
            if (balances[msg.sender] >= amount) {
                balances[toAddress] += amount;
                balances[msg.sender] -= amount;
                recordPayment(msg.sender, toAddress, amount);
                emit Transfer(amount, toAddress);
            } else {
                revert NotEnoughFunds(amount, balances[msg.sender]);
            }
        }
    }
}
