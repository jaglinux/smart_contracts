// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IRarity {
    function adventure(uint _summoner) external;
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function adventurers_log(uint256 tokenId) external view returns (uint256);
}

contract army_adventure {
    IRarity public rarity;
    mapping(address => uint256[]) public army;
    
    constructor(address _rarity_addr) {
        rarity = IRarity(_rarity_addr);
    }
    
    function register_to_army(uint256[] calldata _summoners) external {
        uint256 len = _summoners.length;
        for (uint256 i = 0; i < len; i++) {
            // allowing owners only to add their summoners
            require(msg.sender == rarity.ownerOf(_summoners[i]), "only owner can train");
            army[msg.sender].push(_summoners[i]);
        }
    }
    
    function command_adventure_all() external{
        uint256 len = army[msg.sender].length;
        for(uint256 i = 0; i < len; i++) {
            rarity.adventure(army[msg.sender][i]);
        }
    }
    
    function command_adventure_all_overload(address _commander) external{
        uint256 len = army[_commander].length;
        for(uint256 i = 0; i < len; i++) {
            //allowing anyone to order adventure, why would anyone do so ?!
            rarity.adventure(army[_commander][i]);
        }
    }
    
    function deregister_from_army(uint256 _summoner) external{
        require(msg.sender == rarity.ownerOf(_summoner), "only owner can de register");
        uint256 len = army[msg.sender].length;
        for(uint256 i = 0; i < len; i++) {
            if(army[msg.sender][i] == _summoner) {
                army[msg.sender][i] = army[msg.sender][len-1];
                army[msg.sender].pop();
                return;
            }
        }
    }
}
