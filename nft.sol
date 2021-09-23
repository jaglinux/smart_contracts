pragma solidity ^0.8.0;

contract nft {
    
    struct nft_data {
        uint256 id;
        address owner;
    }
    
    nft_data[] public nft_datas;
    mapping(uint256 => address) public id_to_addr;
    mapping(address => uint256) public number_of_ids_per_address;
    
    function mint() external {
        uint256 id = nft_datas.length;
        nft_data memory item = nft_data({
           id : id,
           owner : msg.sender
        });
        nft_datas.push(item);
        number_of_ids_per_address[msg.sender]+=1;
        id_to_addr[id] = msg.sender;
    }
    
    function balance_of(address _addr) external view returns(uint256) {
        return number_of_ids_per_address[_addr];
    }
    
    function transfer(uint256 _id, address _to) external {
        require(id_to_addr[_id] == msg.sender, "Only owner of the nft can transfer");
        id_to_addr[_id] = _to;
        number_of_ids_per_address[msg.sender]-=1;
        number_of_ids_per_address[_to]+=1;
    }

    function totalSupply() external view returns(uint256) {
        return nft_datas.length;
    }
}
