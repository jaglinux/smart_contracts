// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;
/*
Using a solidity contract, write a method that takes one uint256 and returns a uint8. The return value should be determined by taking each of the digits of the original number and adding them together, repeating until the process results in a number less than 10.
The number could be of any uint256 length.
Logical Example:
Given the number 945, take 9+4+5 which results in 18, then take 1+8 which results in 9, return 9.
*/
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
