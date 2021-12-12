// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

library data {
    struct counter {
        uint256 _val;
    }
    function get(counter storage _data) internal view returns(uint256) {
        return _data._val;
    }
    function incr(counter storage _data) internal {
        _data._val += 1;
    }
    function decr(counter storage _data) internal {
        _data._val -= 1;
    }
}

contract LibraryData {
    data.counter myData;

    function get_data() external view returns(uint256) {
        return data.get(myData);
    }

    function incr_data() external {
        data.incr(myData);
    }

    function decr_data() external {
        data.decr(myData);
    }
}
