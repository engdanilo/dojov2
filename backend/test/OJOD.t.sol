// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/OJOD.sol";

contract OJODTest is Test {

    OJOD ojod;

    function setUp() public {
        ojod = new OJOD(1000000 * 10 ** 18);
    }

    function testInitialSupply() view public {
        uint256 initialSupply = ojod.totalSupply();
        assertEq(initialSupply, 1000000 * 10 ** 18);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        uint256 amount = 100 * 10 ** 18;

        ojod.transfer(recipient, amount);

        uint256 recipientBalance = ojod.balanceOf(recipient);
        assertEq(recipientBalance, amount);
    }
}