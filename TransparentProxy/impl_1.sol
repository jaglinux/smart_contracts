// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

contract Impl_1 {
    address public owner;
    address public impl;
    uint256 public val;

    function incr() external {
        ++val;
    }
}
