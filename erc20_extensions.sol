// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract cappedToken is ERC20Capped, ERC20Burnable {
    address public immutable owner;
    constructor() ERC20("abctoken", "abc") ERC20Capped(100000) {
        owner = msg.sender;
    }
    
    function mint(uint256 _amount) external {
        require(owner == msg.sender, "only owner can mint");
        _mint(msg.sender, _amount);
    }
    
    function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
        ERC20Capped._mint(account, amount);
    }
}

    
    
