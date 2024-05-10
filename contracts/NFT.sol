// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Observers is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint public constant maxSupply = 3;

    bool public publicMintOpen = false;
    bool public whiteListMintOpen = false;

    mapping(address => bool) public whiteList;

    constructor()
        ERC721("Observers", "OBS")
        Ownable(msg.sender)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmbdByibT9vgsK86XpNtDSm6qRChu6vtZbjkixX3FEpH46/";
    }

    // Actualiza la ventana de minting
    function editMintWindows(
        bool _publicMintOpen,
        bool _allowListMintOpen
    ) external onlyOwner {
        publicMintOpen = _publicMintOpen;
        whiteListMintOpen = _allowListMintOpen;
    }

    // Permite mintear a aquellos que estan en la whitelist
    function whiteListMint() external payable {
        require(whiteListMintOpen, "Allow List Mint closed");
        require(whiteList[msg.sender], "You're not whitelisted");
        require(msg.value == 0.001 ether, "Not enough funds");
        require(totalSupply() < maxSupply);
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function publicMint() external payable {
        require(publicMintOpen, "Public Mint closed");
        require(whiteList[msg.sender], "You're not whitelisted");
        require(msg.value == 0.01 ether, "Not enough Funds");
        require(totalSupply() < maxSupply, "We Sold Out");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function addToWhiteList(address[] calldata _addresses) external onlyOwner {
        for (uint256 i; i < _addresses.length; i++){
            whiteList[_addresses[i]] = true;
        }
    }

    // The following functions are overrides required by Solidity.
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
