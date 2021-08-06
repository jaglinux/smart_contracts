pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract priceFeed {
    AggregatorV3Interface aggr;
    constructor() public {
        // eth - usd on Kovan network
        aggr = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }
    
    function get_latest_price() public view returns(int256) {
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = aggr.latestRoundData();
        return answer;
    }
}
