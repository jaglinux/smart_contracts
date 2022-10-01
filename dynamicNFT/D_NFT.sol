
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol";
import "https://github.com/transmissions11/solmate/blob/main/src/utils/LibString.sol";

contract D_NFT is ERC721 {
    using LibString for uint256;
    string public baseURL;
    uint256 totalSupply;
    uint256 constant maxSupply = 10;

    error MintOver();
    
    //Set _base param to https://gateway.pinata.cloud/ipfs/QmU8AZ8wAeNwEfstLkE91FEArPnu9v9BZZegK1SnHcsVnL
    constructor(string memory _name, string memory _symbol, string memory _base) 
        ERC721(_name, _symbol) {
            baseURL = _base;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        return string(abi.encodePacked(baseURL, id.toString(), ".json"));
    }

    function mint() external {
        if(totalSupply > maxSupply) {
            revert MintOver();
        }
        unchecked {
            _mint(msg.sender, ++totalSupply);
        }
    }

}
