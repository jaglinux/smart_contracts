// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Test2 {

    function sum(uint256 value) external returns(uint8) {
        while(value < 10) {
            uint256 temp = value;
            uint256 temp_result;
            while(temp != 0) {
                result += temp % 10;
                temp /= 10;
            }
            value = temp_result;
        }
        return uint8(value);
    }
}
