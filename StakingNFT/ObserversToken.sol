// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ObserversToken is ERC20, Ownable {
    uint256 immutable public TOKEN_PRICE = 0.0001 ether;
    // Nueva variable para guardar la direccion del contrato de staking
    address public s_stakeContract;
    
    constructor()
        ERC20("ObserversToken", "OST")
        Ownable(msg.sender)   
    {
        _mint(owner(), 20_000_000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Nueva funcion mint para que el contrato de staking mintee
    // tokens cada vez que tenga que dar rewards
    function mint(uint256 amount) external onlyStakingContract {
        _mint(s_stakeContract, amount);
    }

    function buy(uint256 amount) public payable {
        require(msg.value == amount * TOKEN_PRICE, "Invalid amount");
        _mint(msg.sender, amount);
    }

    // Nueva funcion para setear el contrato de staking
    function setStakingContract(address _contract) external onlyOwner{
        s_stakeContract = _contract;
    }

    // Modificador para que solo el contrato de staking pueda llamar a la funcion mint
    modifier onlyStakingContract {
        require(msg.sender == s_stakeContract, "You can't mint");
        _;
    }

}
