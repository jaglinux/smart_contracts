// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract FreeMemPointer {
    function readDefaultFreeMem() external pure returns(uint256 a) {
        assembly {
            let free_mem := mload(0x40)
            a := mload(free_mem)
        }
    }

    function readValue() external pure returns(uint256 a) {
        assembly {
            let freeMemPointer := mload(0x40)
            mstore(freeMemPointer, 0x100)
            a := mload(freeMemPointer)
        }
    }
}
