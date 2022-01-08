// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address _source, address _dest, uint256 _value) external;
}
contract swapContract {
    IERC20 erc20;
    constructor(address _addr) {
        erc20 = IERC20(_addr);
    }
    function swap(address _src, address _dest, uint256 _amount) public {
        erc20.transferFrom(_src, _dest, _amount);
    }
}
