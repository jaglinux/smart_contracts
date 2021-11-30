// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol"; 

contract Wrapper is ERC20Wrapper{
    constructor() ERC20Wrapper(IERC20(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8)) 
                  ERC20("stakedTokenA", "stokA") {}
}

contract TokenA is ERC20 {
    constructor() ERC20("TokenA", "tokA"){
        _mint(msg.sender, 1000000 * (10**decimals()));
    }
}
