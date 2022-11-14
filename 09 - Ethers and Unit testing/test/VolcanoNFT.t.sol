// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/VolcanoNFT.sol";

contract VolcanoNFTTest is Test {
    VolcanoNFT public volcanoNFT;

    function setUp() public {
        volcanoNFT = new VolcanoNFT();
    }

    function testMint() public {
        vm.startPrank(address(99));
        // volcanoNFT.mint(address(99));
        volcanoNFT.mint();
        assertEq(volcanoNFT.balanceOf(address(99)), 1);
    }

    function testTotalSupply() public {
        vm.startPrank(address(99));
        // volcanoNFT.mint(address(99));
        volcanoNFT.mint();
        assertEq(volcanoNFT.balanceOf(address(99)), 1);
        assertEq(volcanoNFT.totalSupply(), 1);
    }

    function testTransfer() public {
        vm.startPrank(address(99));
        // volcanoNFT.mint(address(99));
        volcanoNFT.mint();
        assertEq(volcanoNFT.balanceOf(address(99)), 1);
        volcanoNFT.safeTransferFrom(address(99), address(88), 0);
        assertEq(volcanoNFT.balanceOf(address(99)), 0);
        assertEq(volcanoNFT.balanceOf(address(88)), 1);
    }
}
