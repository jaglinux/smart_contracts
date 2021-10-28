// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract my_abi {
    
    event log(bytes);
    
    function callKeccak256(string memory a) public pure returns(bytes32){
        return keccak256(abi.encodePacked(a));
    }
    
    //below 2 functions outputs same results
    function callKeccak256Function_1(string memory a) public pure returns(bytes4) {
        return bytes4(callKeccak256(a));
    }
        
    function callKeccak256Function_2(string memory a) public pure returns(bytes4) {
        return bytes4(keccak256(bytes(a)));
    }
    
    //data field when calling contract function
    //function params are adventure(uint256), 500193
    function constructData(string memory _func, uint256 _val) public {
        bytes memory result = new bytes(64);
        result = abi.encode(callKeccak256Function_1(_func), abi.encodePacked(_val) );
        emit log(result);
    }
    
    //follows abi encoding
    function encodeAbi(string memory a) public pure returns(bytes memory) {
        return abi.encode(a);
    }
    
    //regular utf-8 encoding style
    function encodeAbiPacked(uint256 a) public pure returns(bytes memory) {
        return abi.encodePacked(a);
    }
}

