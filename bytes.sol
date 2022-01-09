// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract byteContract {
    function dummy() public pure returns(string memory) {
        bytes memory c = new bytes(1);
        c[0] = bytes1(uint8(65));
        string memory b = string(c);
        return b;
    }
}
