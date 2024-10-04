// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NKMT.sol";

contract NKMTTest is Test {

    NKMT nkmt;

    function setUp() public {
        nkmt = new NKMT(1000000 * 10 ** 18);
    }

    function testInitialSupply() view public {
        uint256 initialSupply = nkmt.totalSupply();
        assertEq(initialSupply, 1000000 * 10 ** 18);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        uint256 amount = 100 * 10 ** 18;

        nkmt.transfer(recipient, amount);

        uint256 recipientBalance = nkmt.balanceOf(recipient);
        assertEq(recipientBalance, amount);
    }
}