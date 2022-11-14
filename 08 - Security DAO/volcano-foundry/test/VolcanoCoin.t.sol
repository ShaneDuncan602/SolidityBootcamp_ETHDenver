// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VolcanoCoin.sol";

contract VolcanoCoinTest is Test {
    VolcanoCoin public volcanoCoin;
    address owner;

    function setUp() public {
        vm.startPrank(owner);
        volcanoCoin = new VolcanoCoin();
    }

    /// Test that total supply is set correctly
    function testTotalSupply() public {
        assertEq(volcanoCoin.getTotalSupply(), 10000);
    }

    /// Test that owner is working correctly
    function testFailNotOwner() public {
        vm.stopPrank();
        vm.startPrank(address(99));
        volcanoCoin.increaseTotalSupply();
    }

    /// Test that token transfer is functioning properly
    function testTransferToken() public {
        volcanoCoin.transferToken(address(99), 500);
        assertEq(volcanoCoin.getBalance(address(99)), 500);
        assertEq(volcanoCoin.getBalance(owner), 9500);
    }
}
