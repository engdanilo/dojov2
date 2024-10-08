// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract OJOD is IERC20 {

    string public _name = "DojoCoin";
    string public _symbol = "OJOD";
    uint8 public _decimals = 18;
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

        _transfer(msg.sender, recipient, amount);

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

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

     function _approve(address _owner, address spender, uint256 amount) internal {
        require(_owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        allowances[_owner][spender] = amount;

        emit Approval(_owner, spender, amount);
     }

     function allowance(address _owner, address spender) public view returns (uint256) {
        return allowances[_owner][spender];
     }

     function name() public view returns (string memory) {
        return _name;
     }

     function symbol() public view returns (string memory) {
        return _symbol;
     }

     function decimals() public view returns (uint8) {
        return _decimals;
     }
}