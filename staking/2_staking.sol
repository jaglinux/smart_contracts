// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "hardhat/console.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only Owner");
        _;
    }

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        owner = msg.sender;
    }

    function mint(address _dest, uint256 _amount) external onlyOwner {
        _mint(_dest, _amount);
    }
}

contract Stake {
    struct StakeStruct {
        uint256 amount;
        uint256 lastTimeStamp;
        uint256 rewardAmount;
    }
    uint256 public immutable rewardRate;
    ERC20 public erc20Addr;
    mapping(address => StakeStruct) public stakers;

    constructor(address _erc20Addr, uint256 _rewardRate) {
        erc20Addr = ERC20(_erc20Addr);
        rewardRate = _rewardRate;
    }

    function calculateReward(address _addr) public view returns(uint256) {
        StakeStruct storage staker = stakers[_addr];
        uint256 duration = block.timestamp - staker.lastTimeStamp;
        return (rewardRate * duration * staker.amount) / 100;
    }
    function stake(uint256 _amount) external {
        StakeStruct storage staker = stakers[msg.sender];
        erc20Addr.transferFrom(msg.sender, address(this), _amount);
        uint256 reward = calculateReward(msg.sender);

        console.log("stake ", reward);
        staker.lastTimeStamp = block.timestamp;
        staker.amount += _amount;
        staker.rewardAmount += reward;
    }

    function unStake(uint256 _amount) external {
        StakeStruct storage staker = stakers[msg.sender];
        require(staker.amount >= _amount, "not enough balance");
        erc20Addr.transfer(msg.sender, _amount);
        uint256 reward = calculateReward(msg.sender);
        staker.lastTimeStamp = block.timestamp;
        staker.amount -= _amount;
        staker.rewardAmount += reward;
    }

    function balance() external view returns(uint256) {
        return erc20Addr.balanceOf(address(this));
    }

    function claimReward() external {
        StakeStruct storage staker = stakers[msg.sender];
        if(staker.rewardAmount > 0) {
            erc20Addr.transfer(msg.sender, staker.rewardAmount);
            staker.rewardAmount = 0;
        }
    }

}
