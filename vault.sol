// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "hardhat/console.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract AssetERC20 is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only Owner");
        _;
    }
    constructor() ERC20("Asset", "ast") {
        owner = msg.sender;
    }

    function mint(address _dest, uint256 _amount) external onlyOwner {
        _mint(_dest, _amount);
    }

}

contract Vault is ERC20 {
    ERC20 public asset;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(address _asset) ERC20("Vault", "Vlt") {
        asset = ERC20(_asset);
        owner = msg.sender;
    }

    function totalAssets() public view returns(uint256) {
        return asset.balanceOf(address(this));
    }

    function ConvertAssetToShare(uint256 _amount) public view returns(uint256) {
        if(totalSupply() == 0) {
            return _amount;
        }
        else {
            return (_amount * totalSupply()) / totalAssets();
        }
    }

    function ConvertShareToAsset(uint256 _shares) public view returns(uint256) {
        if(totalSupply() == 0) {
            return _shares;
        }
        else {
            return (_shares * totalAssets()) / totalSupply();
        }
    }

    function deposit(uint256 _amount, address _dest) external {
        uint256 shares = ConvertAssetToShare(_amount);
        asset.transferFrom(msg.sender, address(this), _amount);
        _mint(_dest, shares);
    }

    function withdraw(uint256 _shares, address _dest) external {
        uint256 assetGained = ConvertShareToAsset(_shares);
        asset.transfer(_dest, assetGained);
        _burn(msg.sender, _shares);
    }

    function AddAsset(uint256 _amount) external onlyOwner {
        asset.transferFrom(owner, address(this), _amount);
    }
}
