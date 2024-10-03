// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {

    IERC20 public dojoToken;
    IERC20 public ojodToken;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;
    uint256 public rewardRate = 1;

    constructor(address _dojoToken, address _ojodToken) Ownable(address(msg.sender)) {
        dojoToken =  IERC20(_dojoToken);
        ojodToken = IERC20(_ojodToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount moust be greater than 0");
        dojoToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender] = Stake(amount, block.timestamp);
    }

    function unstake() external {
        Stake memory stakeData = stakes[msg.sender];
        require(stakeData.amount > 0, "No tokens staked yet");

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