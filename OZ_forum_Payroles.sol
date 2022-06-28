// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
// Code review from https://forum.openzeppelin.com/t/high-gas-fee-on-withdrawn-function/29985/5
// Original code from https://bscscan.com/address/0xA9ECd08c0faeBFaFdDD0A701eDE23fA08AeB4CF3#code
// Modified original code to fix issues

contract PayRole{

    address owner;
    IERC20  immutable  BUSD;
    mapping(address => bool) allowed;
    mapping(address => uint) allowance;
    mapping(address => uint) moment;

    event devAdded(address);
    event allowanceAdded(address, uint);
    event allowanceRemoved(address, uint);
    event allowanceChanged(address, uint);
    event deposited(address, uint);
    event claimed(address, uint);
    event ownershipTransfered(address);
    event ownerClaimned(uint);


    constructor (address _address)  {
        owner = msg.sender;
        BUSD = IERC20(_address);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    function transferOwnership(address _address) external onlyOwner {
        owner = _address;
    }

    function addDev(address _address, uint _allowance) external onlyOwner {
        allowed[_address] = true;
        moment[_address] = block.timestamp;
        allowance[_address] = _allowance;

        emit devAdded(_address);
        emit allowanceAdded(_address, _allowance);
    }

    function addAllowance(address _address, uint _amount) external onlyOwner {
        allowance[_address] += _amount;
        emit allowanceAdded(_address, _amount);
    }

    function removeAllowance(address _address, uint _amount) external onlyOwner {
        allowance[_address] -= _amount;
        emit allowanceRemoved(_address, _amount);
    }

    function setAllowance(address _address, uint _amount) external onlyOwner{
        allowance[_address] = _amount;
        emit allowanceChanged(_address, _amount);
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0, 'You need to send some tokens!');
        BUSD.transferFrom(msg.sender, address(this), _amount);
        emit deposited(msg.sender, _amount);
    }

    function getReward() external view returns(uint){
        require(allowed[msg.sender] == true, 'This address is not allowed to check getReward');
        return (block.timestamp - moment[msg.sender]) * allowance[msg.sender];
    }

    function claim() external {
        require(allowed[msg.sender] == true, 'This address is not allowed to perform withdrawns');
        uint256 _moment = moment[msg.sender];
        require(BUSD.balanceOf(address(this)) >= (block.timestamp - _moment) * allowance[msg.sender], 'Not enough balance');
        uint amount = _moment * allowance[msg.sender];
        BUSD.transferFrom(address(this), msg.sender, amount);
        allowance[msg.sender] = 0;
        emit claimed(msg.sender, amount);
    }

    function ownerClaim(uint _amount) external onlyOwner {
        BUSD.transferFrom(address(this), msg.sender, _amount);
        emit ownerClaimned(_amount);
    }

    function ownerCheckReward(address _address) external view onlyOwner returns(uint){
        return block.timestamp - moment[_address] * allowance[_address];
    }

}
