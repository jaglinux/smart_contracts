// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CallData {
    function getCallDataSize() external pure returns(uint256 a) {
        assembly {
            a := calldatasize()
        }
    }
    
    function getCallDataSig() external pure returns(bytes4) {
        bytes4 sig;
        assembly {
            let free_mem := mload(0x40)
            calldatacopy(free_mem, 0, 4)
            sig := mload(free_mem)
        }
        require(sig == msg.sig, "wrong function signature");
        return sig;
    }

    function callDummy() external view returns(bytes4) {
        //return dummy() private does not return msg.sig
        return this.dummy();
    }

    function dummy() external pure returns(bytes4) {
        return msg.sig;
    }

}

contract A {
    function dummy() pure public returns(bytes4) {
        return msg.sig;
    }
}
