// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NakamotoCoin {

    string public name = "NakamotoCoin";
    string public symbol = "NKMT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;
        
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function balanceOf(address account) public view returns (uint256) {

        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {

        require(amount == 1*10**decimals, "You can only transfer 1 NKMT at a time");
        _transfer(msg.sender, recipient, amount);

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

        if (msg.sender != owner) {
            require(amount == 1*10**decimals, "You can only transfer 1 NKMT at a time");
        }

        uint256 currentAllowance = allowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

     function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");

        uint256 senderBalance = balances[sender];
        require(senderBalance >= amount, "Transfer amount exceeds balance");
        balances[sender] = senderBalance - amount; // Reintrance protection here
        balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
     }

     function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
     }
}