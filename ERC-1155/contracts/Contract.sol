// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC1155/extensions/ERC1155Supply.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract ObservDevs is ERC1155, Ownable, ERC1155Pausable, ERC1155Supply {
    uint256 public immutable PRICE = 0.01 ether;
    uint256 public immutable WHITELIST_PRICE = 0.001 ether;
    uint8 public immutable maxSupply = 100;

    bool public publicMintOpen = false;
    bool public whitelistMintOpen = true;

    mapping(address => bool) public whitelistMapping;
    
    constructor()
        ERC1155("ipfs://QmTsVf1z4QoHu8s3rpsg9Gdjb59M9ciCtxPZ8VQGqtApHP/")
        Ownable(msg.sender)
    {}

    function addToWhitelist(address _address) external onlyOwner {
        whitelistMapping[_address] = true;
    }

    function removeFromWhitelist(address _address) external onlyOwner {
        whitelistMapping[_address] = false;
    }

    function addManyToWhitelist(address[] calldata _addresses) external onlyOwner {
        for(uint i; i < _addresses.length; i++ ){
            address addressFromArray = _addresses[0];
            whitelistMapping[addressFromArray] = true;
        }
    }

    function removeManyToWhitelist(address[] calldata _addresses) external onlyOwner {
        for(uint i; i < _addresses.length; i++ ){
            address addressFromArray = _addresses[0];
            whitelistMapping[addressFromArray] = false;
        }
    }

    function whitelistMint(uint256 _tokenId, uint256 _amount) public payable {
        require(whitelistMapping[msg.sender], "You're not in the whitelist");
        require(whitelistMintOpen, "Whitelist is Closed");
        require(_tokenId < 2, "Wrong Token ID");
        require(msg.value == WHITELIST_PRICE * _amount, "");
        require(totalSupply(_tokenId) + _amount <= maxSupply, "Sorry we reached the limit of NFTs");
        _mint(msg.sender, _tokenId, _amount, "");
    }

    function mint(uint256 _tokenId, uint256 _amount)
        public
        payable        
    {
        require(publicMintOpen, "Public Mint is Closed");
        require(_tokenId < 2, "Wrong Token ID");
        require(msg.value == PRICE * _amount, "Not enough ether sent");
        require(totalSupply(_tokenId) + _amount <= maxSupply, "Sorry we reached the limit of NFTs");
        _mint(msg.sender, _tokenId, _amount, "");
    }

    function uri(uint256 _tokenId) public view override returns(string memory){
        require(exists(_tokenId), "URI: id doesn't exist");
        return string(abi.encodePacked(super.uri(_tokenId), Strings.toString(_tokenId) ,".json"));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function withdraw(address _to) external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_to).transfer(balance);
    }

    // Functions to close / open minting
    function update(bool _isPublicMintOpen, bool _isWhitelistMintOpen) external onlyOwner {
        publicMintOpen = _isPublicMintOpen;
        whitelistMintOpen = _isWhitelistMintOpen;
    }



    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
