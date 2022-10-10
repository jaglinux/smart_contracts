// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

contract TransparentProxy {

    address public owner;
    address public impl;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "onlyOwner");
        _;
    }

    function upgrade(address _impl) external onlyOwner() {
        impl = _impl;
    }

    function delegate() private returns (bool success, bytes memory data) {
        (success,  data) = impl.delegatecall(msg.data);
    }

    receive() external payable {
        delegate();
    }

    fallback() external payable {
        delegate();
    }
}
