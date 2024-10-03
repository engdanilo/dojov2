### README.md

```markdown
# DOJO Token Project

This project implements an ERC-20 token called DOJO using the OpenZeppelin library. The project includes a frontend developed with React and Bootstrap, and smart contracts written in Solidity using the Foundry framework. This project was developed for the Dojo V2 challenge by NearX and created by Dojo Nakamura.

## Table of Contents

- [Introduction](#introduction)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Contracts](#contracts)
  - [DOJO](#dojo)
  - [OJOD](#ojod)
  - [Staking](#staking)
- [License](#license)

## Introduction

The DOJO Token Project is a decentralized application (dApp) that includes an ERC-20 token with specific transfer restrictions. The frontend is built with React and Bootstrap to provide a user-friendly interface, while the smart contracts are developed using Solidity and the Foundry framework. This project was developed for the Dojo V2 challenge by NearX and created by Dojo Nakamura.

## Technologies Used

- **React**: A JavaScript library for building user interfaces.
- **Bootstrap**: A CSS framework for developing responsive and mobile-first websites.
- **Solidity**: A programming language for writing smart contracts on the Ethereum blockchain.
- **Foundry**: A blazing fast, portable, and modular toolkit for Ethereum application development.

## Installation

### Prerequisites

- Node.js and npm installed
- Foundry installed

### Steps

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd <directory-name>
   ```

2. Install the frontend dependencies:

   ```bash
   cd frontend
   npm install
   ```

3. Compile the smart contracts using Foundry:

   ```bash
   cd ../contracts
   forge build
   ```

## Usage

### Running the Frontend

1. Start the React development server:

   ```bash
   cd frontend
   npm start
   ```

2. Open your browser and navigate to `http://localhost:3000`.

### Deploying the Contracts

1. Configure the environment variables in the `.env` file with the necessary deployment information.

2. Deploy the contracts using Foundry:

   ```bash
   forge create --rpc-url <rpc-url> --private-key <private-key> src/DOJO.sol:DOJO --constructor-args <initial-supply>
   ```

## Contracts

### DOJO

The DOJO contract is an ERC-20 token with specific transfer restrictions. Only 1 token can be transferred at a time for regular users, while the owner can transfer any amount.

#### Code

```solidity
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
```

### OJOD

The OJOD contract is a simple ERC-20 token.

#### Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OJOD is ERC20 {
    constructor(uint256 initialSupply) ERC20("OJOD", "OJOD") {
        _mint(msg.sender, initialSupply);
    }
}
```

### Staking

The Staking contract allows users to stake DOJO tokens and earn rewards in OJOD tokens.

#### Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {
    IERC20 public dojoToken;
    IERC20 public ojodToken;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;
    uint256 public rewardRate = 100; // Example reward rate

    constructor(IERC20 _dojoToken, IERC20 _ojodToken) Ownable(address(msg.sender)) {
        dojoToken = _dojoToken;
        ojodToken = _ojodToken;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        dojoToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender] = Stake(amount, block.timestamp);
    }

    function unstake() external {
        Stake memory stakeData = stakes[msg.sender];
        require(stakeData.amount > 0, "No tokens staked");

        uint256 stakingDuration = block.timestamp - stakeData.timestamp;
        uint256 reward = stakingDuration * rewardRate * stakeData.amount / 1e18;

        dojoToken.transfer(msg.sender, stakeData.amount);
        ojodToken.transfer(msg.sender, reward);

        delete stakes[msg.sender];
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }
}
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.
```

This README.md provides an overview of the project, installation instructions, usage details, and information about the contracts, specifically focusing on the technologies used: React, Bootstrap, Solidity, and Foundry. It also mentions that the project was developed for the Dojo V2 challenge by NearX and created by Dojo Nakamura.