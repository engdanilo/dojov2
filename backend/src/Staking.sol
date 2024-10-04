// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NKMT.sol";

contract Staking {
    NakamotoCoin public nkmt;
    uint256 public airdropAmount;
    uint256 public stakingPeriod;
    uint256 public rewardRate;
    address public owner;

    struct Staker {
        uint256 amount;
        uint256 stakingTime;
    }

    mapping(address => Staker) public stakers;

    event Staked(address indexed user, uint256 amount, uint256 timestamp);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event Airdrop(address indexed user, uint256 amount);
    event RewardRateUpdated(uint256 newRate);

    error InsufficientBalance();
    error NoTokensStaked();
    error StakingPeriodNotOver();
    error NotOwner();

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    constructor(NakamotoCoin _nkmt, uint256 _airdropAmount, uint256 _stakingPeriod, uint256 _initialRewardRate) {
        nkmt = _nkmt;
        airdropAmount = _airdropAmount;
        stakingPeriod = _stakingPeriod;
        rewardRate = _initialRewardRate;
        owner = msg.sender;
    }

    // Function to define the reward rate (onlyOwner)
    function setRewardRate(uint256 _newRate) public onlyOwner {
        rewardRate = _newRate;
        emit RewardRateUpdated(_newRate);
    }

    // Function to stake tokens
    function stake(uint256 _amount) public {
        if (_amount <= 0) {
            revert InsufficientBalance();
        }
        if (nkmt.balanceOf(msg.sender) < _amount) {
            revert InsufficientBalance();
        }

        // Transfer tokens to staking contract
        nkmt.transferFrom(msg.sender, address(this), _amount);

        stakers[msg.sender].amount += _amount;
        stakers[msg.sender].stakingTime = block.timestamp;

        emit Staked(msg.sender, _amount, block.timestamp);
    }

    // Function to unstake tokens
    function unstake() public {
        if (stakers[msg.sender].amount <= 0) {
            revert NoTokensStaked();
        }

        uint256 stakingDuration = block.timestamp - stakers[msg.sender].stakingTime;
        uint256 total = stakingDuration * rewardRate * stakers[msg.sender].amount / 1e18;
        uint256 reward = total - stakers[msg.sender].amount;

        stakers[msg.sender].amount = 0;
        nkmt.transfer(msg.sender, total);

        emit Unstaked(msg.sender, total, reward);
    }

    // Function to airdrop tokens
    function airdrop() public {
        if (stakers[msg.sender].amount <= 0) {
            revert NoTokensStaked();
        }
        if (block.timestamp <= stakers[msg.sender].stakingTime + stakingPeriod) {
            revert StakingPeriodNotOver();
        }

        // Transfer airdrop tokens to staker
        nkmt.transfer(msg.sender, airdropAmount);

        emit Airdrop(msg.sender, airdropAmount);
    }

    // Function to get remaining staking time
    function remainingStakingTime(address _staker) public view returns (uint256) {
        if (block.timestamp >= stakers[_staker].stakingTime + stakingPeriod) {
            return 0;
        } else {
            return (stakers[_staker].stakingTime + stakingPeriod) - block.timestamp;
        }
    }
}