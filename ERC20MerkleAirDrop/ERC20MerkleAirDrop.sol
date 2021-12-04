// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract TokenA is ERC20 {
    constructor(string memory _name, string memory _symbol, uint256 supply ) ERC20(_name, _symbol) {
        _mint(msg.sender, supply * (10 ** decimals()));
    }
}

contract ERC20MerkleAirDrop {
    bytes32 public merkleRoot;
    IERC20 public token;
    bool public lastResult;

    constructor(bytes32 _hash, IERC20 _addr) {
        merkleRoot = _hash;
        token = _addr;
    }

    function claim(bytes32[] calldata _proof, address _claimer) public returns(bool) {
        require(_claimer != address(0), "no 0 address please");
        bytes32 _hash = keccak256(abi.encodePacked(_claimer));
        lastResult =  MerkleProof.verify(_proof, merkleRoot, _hash);
        if(lastResult == true) {
            token.transfer(_claimer, 100);
        }
        return lastResult;
    }
}
