// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract A {
    uint256 public counter;

    function increment() external {
        counter += 1;
    }
}

contract Update {
    uint256 public counter;

    function increment() external {
        counter += 100;
    }
}

contract B {
    uint256 public counter;
    address public owner;
    address public proxy;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) external {
        require(msg.sender == owner, "only Owner");
        owner = _newOwner;
    }

    function setProxy(address _newProxy) external {
        require(msg.sender == owner, "only Owner");
        proxy = _newProxy;
    }

    function increment() external returns(bool, bytes memory) {
        (bool flag, bytes memory data) = proxy.delegatecall(abi.encodeWithSignature("increment()"));
        return (flag, data);
    }

}
