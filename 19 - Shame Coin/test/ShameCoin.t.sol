// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ShameCoin.sol";

contract ShameCoinTest is Test {
    ShameCoin public shameCoin;

    address public constant adminAddress = address(99);
    address public constant userAddress = address(88);
    address public constant userAddress2 = address(77);

    function setUp() public {
        shameCoin = new ShameCoin(adminAddress);
    }

    function testDecimal() public {
        assertEq(shameCoin.decimals(), 0);
    }

    function testTransfer() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1);
        assertEq(shameCoin.balanceOf(userAddress), 1);
    }

    function testFailTransferForNonAdmin() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1); //Load userAddress with a token
        assertEq(shameCoin.balanceOf(userAddress), 1);
        switchToUser(); //switch to user account
        shameCoin.transfer(userAddress, 1); //try to transfer
        assertEq(shameCoin.balanceOf(userAddress), 1); // make sure it didn't tranfer
    }

    function testTransferForNonAdminPunishes() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1); //Load userAddress with a token
        assertEq(shameCoin.balanceOf(userAddress), 1);
        switchToUser(); //switch to user account
        shameCoin.transfer(userAddress2, 1); //try to transfer
        assertEq(shameCoin.balanceOf(userAddress2), 0); // make sure it did not transfer
        assertEq(shameCoin.balanceOf(userAddress), 2); // make sure it punished
    }

    function testTransferFromWithApprove() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1);
        assertEq(shameCoin.balanceOf(userAddress), 1);
        switchToUser();
        shameCoin.approve(adminAddress, 1);
        switchToAdmin();
        shameCoin.transferFrom(userAddress, userAddress2, 1);
        assertEq(shameCoin.balanceOf(userAddress2), 1);
        assertEq(shameCoin.balanceOf(userAddress), 0);
    }

    function testTransferFromWithIncreaseAllowance() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1);
        assertEq(shameCoin.balanceOf(userAddress), 1);
        switchToUser();
        shameCoin.increaseAllowance(adminAddress, 1);
        switchToAdmin();
        shameCoin.transferFrom(userAddress, userAddress2, 1);
        assertEq(shameCoin.balanceOf(userAddress2), 1);
        assertEq(shameCoin.balanceOf(userAddress), 0);
    }

    function testIncreaseAllowanceMoreThanOne() public {
        switchToUser();
        vm.expectRevert("May only allow spending of one token");
        shameCoin.increaseAllowance(adminAddress, 2);
    }

    function testTransferFromWithMoreThanOne() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1);
        assertEq(shameCoin.balanceOf(userAddress), 1);
        switchToUser();
        shameCoin.approve(adminAddress, 1);
        switchToAdmin();
        vm.expectRevert("Can only send one token at a time");
        shameCoin.transferFrom(userAddress, userAddress2, 2);
    }

    function testFailTransferFromWithNoAllowance() public {
        switchToAdmin();
        shameCoin.transfer(userAddress, 1);
        assertEq(shameCoin.balanceOf(userAddress), 1);
        shameCoin.transferFrom(userAddress, userAddress2, 1);
        assertEq(shameCoin.balanceOf(userAddress2), 1);
        assertEq(shameCoin.balanceOf(userAddress), 0);
    }

    function switchToAdmin() public {
        vm.stopPrank();
        vm.startPrank(adminAddress);
    }

    function switchToUser() public {
        vm.stopPrank();
        vm.startPrank(userAddress);
    }
}
