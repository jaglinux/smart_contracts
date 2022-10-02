// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

contract StringLib {

    bytes10 constant STRING = "0123456789";
    function itoa(uint256 i) external pure returns(string memory) {
        uint256 j = i;
        uint256 len;
        while(j != 0) {
            ++len;
            j /= 10;
        }
        if(len == 0) return string(abi.encodePacked("0"));
        bytes memory a = new bytes(len);
        for(j=0; j < len; ++j) {
            a[j] = STRING[i%10];
            i /= 10;
        }
        bytes memory b = new bytes(len);
        uint256 k;
        for(j=len; j > 0 ; --j) {
            b[k] = a[j-1];
            ++k;
        }
        return string(b);
    }
}
