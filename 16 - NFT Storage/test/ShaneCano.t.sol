// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/ShaneCanoNFT.sol";
import "../src/ShaneCoin.sol";
import "../src/Counter.sol";

contract ShaneCanoNFTTest is Test {
    ShaneCanoNFT public shaneCanoNFT;
    ShaneCoin public shaneCoin;
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        console.log("after Counter");
        shaneCoin = new ShaneCoin();
        console.log("after ShaneCoin");
        shaneCanoNFT = new ShaneCanoNFT();
        shaneCanoNFT.setShaneCoinAddress(address(shaneCoin));
        console.log("after ShaneCanoNFT");
    }

    function testMint() public {
        // vm.startPrank(address(99));
        vm.deal(address(99), 10 ether);
        shaneCanoNFT.mintWithEther{value: .01 ether}(address(99));
        assertEq(shaneCanoNFT.balanceOf(address(99)), 1);
    }

    function testMintWithShaneCoin() public {
        shaneCoin.approve(address(shaneCanoNFT), 1);
        shaneCanoNFT.mintWithShaneCoin(address(99), 1);
        assertEq(shaneCanoNFT.shaneCoinAmount(), 1);
        assertEq(shaneCanoNFT.balanceOf(address(99)), 1);
    }
}
