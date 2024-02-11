// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract erc20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    address public owner;
    uint8 public constant decimals=18;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    event mint(address, uint256);
    event transferLog(address, address, uint256);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        _mint(msg.sender, 25000000 * (10 ** decimals));
    }

    function _mint(address _dest, uint256 _amount) private {
        require(msg.sender == owner, "only Owner");
        totalSupply += _amount;
        balances[_dest] += _amount;
        emit mint(_dest, _amount);
    }

    function transfer(address _dest, uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "not enough balance");
        _transfer(msg.sender, _dest, _amount);
    }

    function _transfer(address _src, address _dest, uint256 _amount) private {
        balances[_src] -= _amount;
        balances[_dest] += _amount;
        emit transferLog(_src, _dest, _amount);
    }

    function approve(address _dest, uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "not enough balance");
        allowances[msg.sender][_dest] = _amount;
    }

    function transferFrom(address _src, address _dest, uint256 _amount) external {
        require(balances[_src] >= _amount, "not enough balance");
        require(allowances[_src][msg.sender] >= _amount, "not enough allowances");
        _transfer(_src, _dest, _amount);
        allowances[_src][msg.sender] -= _amount;
    }
}
