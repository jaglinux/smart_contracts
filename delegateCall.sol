// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Impl1 {
    uint256 public counter;

    function increment() external {
        counter += 1;
    }
}

contract Impl2 {
    uint256 public counter;

    function increment() external {
        counter += 100;
    }
}

contract Proxy {
    uint256 public counter;
    address public owner;
    address public impl;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) external {
        require(msg.sender == owner, "only Owner");
        owner = _newOwner;
    }

    function setImplementation(address _newImpl) external {
        require(msg.sender == owner, "only Owner");
        impl = _newImpl;
    }

    function increment() external returns(bool, bytes memory) {
        (bool flag, bytes memory data) = impl.delegatecall(abi.encodeWithSignature("increment()"));
        return (flag, data);
    }

}
