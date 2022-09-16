// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol";

contract D_NFT is ERC721 {

    string public baseURI_string;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function tokenURI(uint256 id) public view virtual override returns (string memory) {}

    function _setBaseURI(string baseURI) private {
        baseURI_string = baseURI;
    }

}
