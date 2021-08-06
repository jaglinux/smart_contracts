pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract ApiConsumer is ChainlinkClient {
    uint256 public volume;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10 ** 18;
    }
    
    function requestVolume() public returns(bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
        req.add("path", "RAW.ETH.USD.VOLUME24HOUR");
        req.addInt("times", 10**18);
        return sendChainlinkRequestTo(oracle, req, fee);
    }
    
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId) {
        volume = _volume;
    }
}
