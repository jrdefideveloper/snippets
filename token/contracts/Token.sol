pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/token/ERC20/Extensions/ERC20Capped.sol"; 
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol"; 

contract MyToken is ERC20Capped, Ownable { 
    constructor() ERC20("MyToken", "MT") ERC20Capped(100000) { 
        ERC20._mint(msg.sender, 1000); 
    }
}