// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract A {
    event log(string);
    function echo() public {
        emit log("test echo from A");
    }
}

//Pass A address to call log from contract A
//Pass Hack address to call log from contract hack even though contract type param is contract A !!!
contract B {
    function echo(address a) public {
        A(a).echo();
    }
    
    function echo1(A a) public {
        a.echo();
    }
}
