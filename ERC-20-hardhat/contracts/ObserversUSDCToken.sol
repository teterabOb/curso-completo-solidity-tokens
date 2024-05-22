// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ObserversUSDCToken is ERC20, Ownable {
    
    constructor()
        ERC20("ObserversToken", "OUSDC")
        Ownable(msg.sender)        
    {
        _mint(owner(), 20_000_000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns(uint8){
        return 6;
    }
}

