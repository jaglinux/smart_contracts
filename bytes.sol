// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract byteContract {
    function dummy() public pure returns(string memory) {
        bytes memory c = new bytes(1);
        c[0] = bytes1(uint8(65));
        string memory b = string(c);
        return b;
    }

    function compare(string memory a, string memory b) public pure returns(bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function concat(string memory a, string memory b) public pure returns(string memory) {
        return string(abi.encodePacked(a, b));
    }

    function itoa(uint256 num) public pure returns(string memory) {
        uint256 digits;
        uint256 num1 = num;
        while(num1 != 0) {
            digits+=1;
            num1 /= 10;
        }
        bytes memory str = new bytes(digits);
        for(uint256 i=digits; i > 0 ; i-- ) {
            str[i-1] = bytes1(uint8(48 + uint256(num%10)));
            num /= 10;
        }
        return string(str);
    }
}
