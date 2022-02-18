// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WarmSlot {
    uint256 globalSlot = 1;
    event log(uint256);

    modifier reentrant() {
        uint256 g = gasleft();
        uint256 a = globalSlot;
        require(g - gasleft() >= 1000, "reentrant detected");
        _;
    }

    function goodTxn() external reentrant {
    }

    function badTxn() external reentrant reentrant{
    }

    function calculateGasSlot() external {
        uint256 g = gasleft();
        uint256 a = globalSlot;
        emit log(g - gasleft());
        g = gasleft();
        a = globalSlot;
        emit log(g - gasleft());
    }
}
