// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract NKMT is IERC20 {

    string public _name = "NakamotoCoin";
    string public _symbol = "NKMT";
    uint8 public _decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) private allowances;
    mapping(address => bool) private _verifiedAccounts;
    mapping(address => bool) private _initialTokensGranted;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error AccountAlreadyVerified();
    error NotOwner();
    error InvalidAddress();

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
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

    function verifyAccount(address account) public {
        if (_verifiedAccounts[account]) {
            revert AccountAlreadyVerified();
        }

        _verifiedAccounts[account] = true;

        if (!_initialTokensGranted[account]) {
            balances[account] += 10 * (10 ** uint256(18)); // 18 decimais
            _initialTokensGranted[account] = true;

            totalSupply += 10 * (10 ** uint256(18));
        }
    }

    function isVerified(address account) public view returns (bool) {
        return _verifiedAccounts[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {

        require(amount == 1*10**decimals(), "You can only transfer 1 NKMT at a time");
        _transfer(msg.sender, recipient, amount);

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

        if (msg.sender != owner) {
            require(amount == 1*10**decimals(), "You can only transfer 1 NKMT at a time");
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
        if (sender == address(0) || recipient == address(0)) {
            revert InvalidAddress();
        }
        if (!_verifiedAccounts[sender]) {
            verifyAccount(sender);
        }

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