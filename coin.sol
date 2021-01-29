
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract coin {
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 total;
    string public constant symbol = "rough";
    
    constructor(uint256 _total) {
        balances[msg.sender] = _total;
        total = _total;
    }
    
    function totalSuply() public view returns (uint256) {
        return total;
    }
    
    function balanceOf(address owner) public view returns(uint256) {
        return balances[owner];
    }
    
    function transfer(address dest, uint256 value) public returns(bool) {
        require(balances[msg.sender] >= value);
        balances[msg.sender] -= value;
        balances[msg.sender] += value;
        return true;
    }
    
    function approve(address delegate, uint256 value) public returns(bool) {
        allowed[msg.sender][delegate] = value;
        return true;
    }
    
    function allowance(address owner, address delegate) public view returns(uint256) {
        return allowed[owner][delegate];
    }
    
    function transferfrom(address source, address dest, uint256 value) public returns(bool) {
        require(balances[source] >= value);
        require(allowed[source][msg.sender] >= value);  
        balances[source] -= value;
        balances[dest] += value;
        allowed[source][msg.sender] -= value;
        return true;
    }
    
}
