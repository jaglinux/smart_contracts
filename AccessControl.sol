// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    //Get the hash by making ownerHash an userHash as public, after that make it private 
    // to same some gas!!!
    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ownerHash = keccak256(abi.encodePacked("ADMIN"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant userHash = keccak256(abi.encodePacked("USER"));

    mapping(bytes32 => mapping(address => bool)) public access;
    
    constructor() {
        _setAccessControl(ownerHash, msg.sender);
    }

    modifier onlyAdmin(bytes32 _hash) {
        require(access[_hash][msg.sender], "no access");
        _;
    }

    function _setAccessControl(bytes32 _hash, address _addr) private {
        access[_hash][_addr] = true;
    }

    //set address to user group , not admin group
    function setAccessControl(bytes32 _hash, address _addr) public onlyAdmin(ownerHash) {
        _setAccessControl(_hash, _addr);
    }

}

