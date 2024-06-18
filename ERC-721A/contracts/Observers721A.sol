//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//import "./ERC721A.sol";
// Ocupar esta URL para Remix e importarlo desde el Repositorio
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract Observers721A is ERC721A, ERC2981 {
    uint8 private s_mintLimitPerAddress = 3;
    uint8 private s_LimitOfNFTs = 10;
    uint256 private constant s_price = 0.001 ether;
    string private s_baseUri;

    //Mapping para manejar los tokens que han minteado los usuarios
    mapping(address => uint256) public s_nftsMintedByUser;

    constructor() ERC721A("Observers721A", "OBS") {
        s_baseUri = "ipfs://QmRZF8ZR4ZFbfw826vogFzpU5tkZb2iz3Jbbvc1N72FM4L/";
    }

    // Según la documentación del ERC-721A, si vamos a implementar
    // el estándar ERC2981, debemos sobrescribir esta función
    // Valida las interfaces ERC721A y ERC2981 para no tener errores en tiempos de ejecucion cuando
    // otros contratos interactúan con nuestro contrato
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        virtual
        override(ERC721A, ERC2981)
        returns (bool)
    {
        return
            ERC721A.supportsInterface(_interfaceId) ||
            ERC2981.supportsInterface(_interfaceId);
    }

    function mint(uint256 quantity) external payable isTotalReached(quantity) {
        require(
            quantity <= s_mintLimitPerAddress && 
            s_nftsMintedByUser[msg.sender] + quantity <= s_mintLimitPerAddress
            , "Limit per address reached"
        );        
        require(msg.value >= s_price * quantity, "Not enough ether");
        s_nftsMintedByUser[msg.sender] += quantity;
        _mint(msg.sender, quantity);
    }


    modifier isTotalReached(uint256 quantity) {
        require(totalSupply() + quantity <= s_LimitOfNFTs, "Limit Reached");
        _;
    }

    // Sobre escribimos esta funcion para poder retornar la URI base que corresponde
    // Esta URI la vamos a setear en el constructor
    function _baseURI() internal view virtual override returns (string memory) {
        return s_baseUri;
    }
}
