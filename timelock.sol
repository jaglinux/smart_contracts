// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract timelock {
    uint256 public origin_block;
    uint256 public origin_timestamp;
    uint256 a;
    address payable public owner;
    
    constructor() payable {
        origin_block = block.number;
        origin_timestamp = block.timestamp;
        owner = msg.sender;
    }
    
    //for local test network, call dummy to mine the block !
    function dummy() public {
        a++;
    }
    
    function withdraw() external {
        require(msg.sender == owner);
        require(block.number >= origin_block + 5);
        owner.transfer(address(this).balance);
    }
}
