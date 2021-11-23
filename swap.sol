// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Atoken is ERC20 {
    constructor(string memory _name, string memory _symbol, uint256 amount) ERC20(_name, _symbol) {
        _mint(msg.sender, amount * (10 ** decimals()));
    }
}

contract Btoken is ERC20 {
    constructor(string memory _name, string memory _symbol, uint256 amount) ERC20(_name, _symbol) {
        _mint(msg.sender, amount * (10 ** decimals()));
    }
}

contract swap {
    Atoken public immutable a;
    Btoken public immutable b;
    
    constructor(address _tokenA, address _tokenB) {
        a = Atoken(_tokenA);
        b = Btoken(_tokenB);
    }
    
    //_ownerA should approve this contract to spend token on its behalf
    //same comment for _ownerB
    function swapToken(address _ownerA, uint256 _amountA, address _ownerB, uint256 _amountB) external {
        a.transferFrom(_ownerA, _ownerB, _amountA);
        b.transferFrom(_ownerB, _ownerA, _amountB);
    }
}
