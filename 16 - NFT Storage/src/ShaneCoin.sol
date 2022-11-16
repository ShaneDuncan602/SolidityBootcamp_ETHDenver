// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "openzeppelin-contracts/access/Ownable.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

/**
 * @title ShaneCoin
 * @author @ShaneDuncan602
 * @notice Lesson 4 of ETHDenver
 */
contract ShaneCoin is Ownable, ERC20 {
    mapping(address => uint256) public balances;
    struct Payment {
        address recipientAddress;
        uint256 amount;
    }

    event IncreaseTotalSupply(uint256 newSupply);

    constructor() ERC20("Shane", "SHNCO") {
        _mint(msg.sender, 10000 * 10**decimals());
        balances[msg.sender] = 10000;
    }

    /// Increase total supply by 1000
    function increaseTotalSupply() public onlyOwner {
        _mint(owner(), 1000);
        emit IncreaseTotalSupply(totalSupply());
    }
}
