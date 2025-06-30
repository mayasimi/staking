// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract EthStaking {
    address public owner;
    IERC20 public rewardToken;

    mapping(address => uint256) public balances;

    constructor(address _rewardToken) {
        owner = msg.sender;
        rewardToken = IERC20(_rewardToken);
    }

    // Receive ETH and update staking balance
    function stake() external payable {
        require(msg.value > 0, "Stake must be > 0");
        balances[msg.sender] += msg.value;
    }

    // Simple reward distribution by owner
    function distributeReward(address staker, uint256 rewardAmount) external {
        require(msg.sender == owner, "Only owner can distribute rewards");
        rewardToken.transfer(staker, rewardAmount);
    }

    // Allow withdrawal of staked ETH
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "ETH Transfer failed");
    }

    // Fallback for direct ETH transfers
    receive() external payable {}
}
