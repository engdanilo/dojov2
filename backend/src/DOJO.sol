// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DOJO is ERC20, Ownable {

    constructor(uint256 initialSupply) ERC20("DOJO", "DOJO") Ownable(address(msg.sender)) {
        _mint(msg.sender, initialSupply);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount == 1*10**decimals(), "You can only transfer 1 DOJO at a time");
        return super.transfer(recipient, amount);
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        if (msg.sender != owner()) {
            require(amount == 1*10**decimals(), "You can only transfer 1 DOJO at a time");
        }
        return super.transferFrom(sender, recipient, amount);
    }
}