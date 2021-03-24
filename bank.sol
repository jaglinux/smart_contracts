contract bank {
    mapping(address => uint256) public balance;
    
    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) public {
        require(amount <= balance[msg.sender]);
        balance[msg.sender] -= amount;
        // transfer at end to prevent re-entrant hack
        msg.sender.transfer(amount);
    }
}
