// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract base {
    address public owner;
    uint256 public b;
    event log(string);
    constructor(uint256 _b) {
        owner = msg.sender;
        b = _b;
    }
    function dummy() public virtual {
        emit log("base");
    }
}

contract base1 {
    uint256 public a;

    constructor(uint256 _a) {
        a = _a;
    }

    event log1(string);
    function dummy() public virtual {
        emit log1("base1");
    }
}

contract A is base, base1 {
    constructor(uint256 z) base(z*2) base1(z ** 2) {
    }

    function dummy() public override(base, base1) {
        emit log("derivedx");
        base.dummy();
        base1.dummy();
    }
}
