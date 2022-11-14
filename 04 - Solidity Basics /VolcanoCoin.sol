// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @title VolcanoCoin
 * @author @ShaneDuncan602
 * @notice Lesson 4 of ETHDenver
 */
contract VolcanoCoin {
    uint256 public totalSupply = 10000;
    address owner;
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

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    /// Getter for totalSupply
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
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
                emit Transfer(amount, toAddress);
                payment = Payment(toAddress, amount);
                payments[msg.sender].push(payment);
            } else {
                revert NotEnoughFunds(amount, balances[msg.sender]);
            }
        }
    }
}
