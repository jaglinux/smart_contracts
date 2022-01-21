// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;
import "hardhat/console.sol";

/*
Using a solidity contract, write a method that takes two uint256 arrays and returns uint256 array with only the items that are in one but not both arrays.
Logical Example:
Given [1, 34, 5, 7, 62] and [7, 34, 9, 5, 6], you should return an array containing [1, 62, 9, 6] (order does not matter)
*/

/*
//Sorting function credit to https://gist.github.com/subhodi/b3b86cc13ad2636420963e692a4d896f
contract Test1 {

    uint256[] result;

    function sort(uint256[] memory data) internal  returns(uint256[] memory) {
       quickSort(data, int(0), int(data.length - 1));
       return data;
    }
    
    function quickSort(uint256[] memory arr, int left, int right) internal {
        int i = left;
        int j = right;
        if(i==j) return;
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }

    function diff(uint256[] memory left, uint256[] memory right) external returns(uint256[] memory) {
        left = sort(left);
        right = sort(right);
        uint256 len_left = left.length;
        uint256 len_right = right.length;
        uint256 i;
        uint256 j;

        while(i < len_left || j < len_right) {
            if(i >= len_left) {
                for(;j < len_right; j++) {
                    result.push(right[j]);
                }
                break;
            }
            if(j >= len_right) {
                for(;i < len_left; i++) {
                    result.push(left[i]);
                }
                break;
            }
            if(left[i] == right[j]) {
                i++;
                j++;
            }
            else if (left[i] < right[j]) {
                result.push(left[i]);
                i++;
            }
            else {
                result.push(right[j]);
                j++;
            }
        }
        return result;
    }
}
