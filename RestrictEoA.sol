pragma solidity ^0.8.0;

contract test {
    bool public hack;
    
    //allow only EOA to interact, block contracts from calling
    function try_to_hack() external {
        uint256 size;
        address addr = msg.sender;
        assembly {
            size := extcodesize(addr)
        }
        require(size == 0, "only EOA can access further");
        hack = true;
    }
    
    //allow only EOA to interact, block contracts from calling
    function try_to_hack_1() external {
        require(tx.origin == msg.sender, "only EOA can access further");
        hack = true;
    }
    
    function reset_variable() external {
        //anyone can reset, we dont care
        hack = false;
    }
}

contract hacker {
    constructor(address _addr) {
        //possible to access !
        test(_addr).try_to_hack();
        //will revert
        //test(_addr).try_to_hack_1();
    }
    
    function callTest(address _addr) external {
        //will revert
        test(_addr).try_to_hack();
    }
}
