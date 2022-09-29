// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

//cast sig "changeValue(uint256)"
//0xf965e32e
//cast abi-encode "changeValue(uint256)" 5
//0x0000000000000000000000000000000000000000000000000000000000000005
//QueueProposal() params
//0xf8e81D47203A594245E36C48e151709F0C19fBe8, "0xf965e32e", "0x0000000000000000000000000000000000000000000000000000000000000005", 1664440900


contract Timelock {
    error ProposalListed();
    error ProposalTSError();
    error ProposalExecuted();
    error OnlyOwner();
    error ProposalNotListed();
    error ProposalTimeExpired();
    error ExecutionFailed();

    address public owner;
    uint256 public constant MIN_DELAY = 10 seconds;
    uint256 public constant MAX_DELAY = 1000 seconds;
    uint256 public constant GRACE_PERIOD = 1000 seconds;


    struct Proposal {
        bool listed;
        bool executed;
    }

    mapping(bytes32 => Proposal) public Proposals;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if(msg.sender != owner) revert OnlyOwner();
        _;
    }

    function getBlockTimeStamp() external view returns(uint256) {
        return block.timestamp;
    }

    function QueueProposal(address _addr, bytes4 _func, bytes memory _param, uint256 _ts) 
        external onlyOwner returns(bytes32 _hash) {
            _hash = getHash(_addr, _func, _param, _ts);
            if(Proposals[_hash].listed == true) 
                revert ProposalListed();
            if(Proposals[_hash].executed == true)
                revert ProposalExecuted();
            if(_ts < (block.timestamp+MIN_DELAY) || _ts > (block.timestamp+MAX_DELAY)) 
                revert ProposalTSError();
            Proposals[_hash].listed = true;
    }

    function ExecuteProposal(address _addr, bytes4 _func, bytes memory _param, uint256 _ts) 
        external {
        bytes32 _hash = getHash(_addr, _func, _param, _ts);
        if(Proposals[_hash].listed == false) 
            revert ProposalNotListed();
        if(Proposals[_hash].executed == true)
            revert ProposalExecuted();
        if(block.timestamp > (_ts+GRACE_PERIOD))
            revert ProposalTimeExpired();
        (bool success, bytes memory log) = _addr.call(abi.encode(_func, _param));
        if(success) {
            Proposals[_hash].executed = true;
        }
        else {
            revert ExecutionFailed();
        }
    }
    
    function getHash(address _addr, bytes4 _func, bytes memory _param, uint256 _ts) internal pure 
        returns(bytes32) {
            return keccak256(abi.encodePacked(_addr, _func, _param, _ts));
    }

}

contract Test {
    error NotAuth();

    uint256 public value;
    address public timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
        value = 1;
    }

    function changeValue(uint256 _value) external {
        if(msg.sender != timeLock) revert NotAuth();
        value = _value;
    }
}
