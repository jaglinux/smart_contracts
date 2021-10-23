// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Token is ERC20,Ownable {
    //Solidity does not support mapping iterations
    //Use array value to index into mappings
    mapping(address => uint256) public staked;
    mapping(address => uint256) public rewards;
    address[] public registeredAddress;
    uint256 public rewardsPercentage = 1;
    
    constructor(address _owner, uint256 _supply) ERC20("Jag Token", "jag"){
        _mint(_owner, _supply * (10 ** decimals()));
    }
    
    function isRegistered(address _addr) private view returns(bool) {
        uint256 len = registeredAddress.length;
        for(uint256 i=0; i < len; i++) {
            if(_addr == registeredAddress[i]) {
                return true;
            }
        }
        return false;
    }
    
    function registerToStake(address _addr) private {
        registeredAddress.push(_addr);
    }
    
    function deregisterToStake(address _addr) private {
        uint256 len= registeredAddress.length;
        for(uint256 i=0; i < len; i++) {
            if(registeredAddress[i] == _addr) {
                registeredAddress[i] = registeredAddress[len-1];
                registeredAddress.pop();
                return;
            }
        }
    }
    
    function stake(uint256 _amount) external {
        require(balanceOf(msg.sender) >= _amount, "staking amount is more than balance");
        //transfer(address(this), _amount);
        if(isRegistered(msg.sender) == false) {
            registerToStake(msg.sender);
        }
        _burn(msg.sender, _amount);
        staked[msg.sender] += _amount;
    }
    
    function unstake(uint256 _amount) external {
        require(staked[msg.sender] >= _amount, "staked amount is less than withdrawl amount");
        staked[msg.sender] -= _amount;
        if(staked[msg.sender] == 0) {
            deregisterToStake(msg.sender);
            //harvest if reward amount is not 0
            if(rewards[msg.sender] > 0) {
                harvest(rewards[msg.sender]);
            }
            //flush rewards
            rewards[msg.sender] = 0;
        }
        //_transfer(address(this), msg.sender, _amount);
        _mint(msg.sender, _amount);
    }
    
    function changeRewardsPercentage(uint256 _val) external onlyOwner {
        rewardsPercentage = _val;
    }
    
    function calculateReward(address _addr) private view returns(uint256 reward){
        reward = (staked[_addr] * rewardsPercentage) / 100;
    }
    
    function distributeRewards() external onlyOwner {
        uint256 len = registeredAddress.length;
        for(uint256 i=0; i < len; i++) {
            address addr = registeredAddress[i];
            rewards[addr] += calculateReward(addr);
        }
    }
    
    function harvest(uint256 _amount) public {
        require(rewards[msg.sender] > 0, "Sorry, no rewards");
        rewards[msg.sender] -= _amount;
        _mint(msg.sender, _amount);
    }
}
