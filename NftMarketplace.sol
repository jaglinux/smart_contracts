// SPDX-License-Identifier: MIT
// Credit https://gist.github.com/dabit3/eb8866adc22bd86cabf5e6604b408e4a
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NftMarketplace is ERC721URIStorage {
  uint256 public listingPrice;
  uint256 tokenId;
  uint256 itemsListed;

  struct MarketItem {
    uint256 id;
    address owner;
    bool IsListed;
    uint256 price;
  }

  mapping(uint256 => MarketItem) MarketItems;
  address payable public owner;
  
  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol)  {
    owner = payable(msg.sender);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only Owner");
    _;
  }

  function changeListingPrice(uint256 _price) external onlyOwner {
    listingPrice = _price;
  }

  function createToken(string calldata url) external returns(uint256) {
    _mint(msg.sender, tokenId);
    _setTokenURI(tokenId, url);
    MarketItem memory temp = MarketItem(tokenId, msg.sender, false, 0);
    MarketItems[tokenId] = temp;
    tokenId++;
    return tokenId -1 ;
  }

  function listItem(uint256 _tokenId, uint256 _price) payable external{
    require(msg.sender == ownerOf(_tokenId), "only owner can list");
    require(msg.value == listingPrice, "please pay platform listing price");
    MarketItem memory temp = MarketItems[_tokenId];
    require(temp.IsListed == false, "Already Listed");
    temp.IsListed = true;
    temp.price = _price;
    MarketItems[_tokenId] = temp;
    _transfer(msg.sender, address(this), _tokenId);
    itemsListed++;
  }

  function removeListing(uint256 _tokenId) external {
    require(msg.sender == ownerOf(_tokenId), "only owner can unlist");
    MarketItem memory temp = MarketItems[_tokenId];
    require(temp.IsListed == true, "Not Listed");
    temp.IsListed = false;
    temp.price = 0;
    MarketItems[_tokenId] = temp;
    _transfer(address(this), msg.sender, _tokenId);
    itemsListed--;
  }

  function editListing(uint256 _tokenId, uint256 _price) external {
    require(msg.sender == ownerOf(_tokenId), "only onwer can edit");
    require(_price != 0, "call removeListing");
    MarketItem memory temp = MarketItems[_tokenId];
    require(temp.IsListed == true, "Not Listed");
    temp.price = _price;
    MarketItems[_tokenId] = temp;
  }

  function buy(uint256 _tokenId) external payable returns(bool, bytes memory) {
    MarketItem memory temp = MarketItems[_tokenId];
    require(msg.value == temp.price, "plz transfer listing price");
    (bool success, bytes memory data) = payable(temp.owner).call{value:msg.value}("");
    if(success == true) {
      _transfer(address(this), msg.sender, _tokenId);
      temp.owner = msg.sender;
      temp.IsListed = false;
      temp.price = 0;
    }
    return (success, data);
  }

  function getAllListedItems() public view returns(MarketItem[] memory) {
    MarketItem[] memory list = new MarketItem[](itemsListed);
    for(uint256 i=0; i < tokenId; i++) {
      if(MarketItems[i].IsListed == true) {
        list[i] = MarketItems[i];
      }
    }
    return list;
  }

  function transferFundtoPlatform(uint256 _val) external onlyOwner returns(bool success, bytes memory data) {
    require(_val <= address(this).balance , "not enough fund available");
    (success, data) = owner.call{value:_val}("");
  }

 // Never use this ! RUGPULL !!!
  function destroy() external onlyOwner {
    selfdestruct(owner);
  }
}
