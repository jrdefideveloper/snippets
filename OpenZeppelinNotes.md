# OpenZeppelin 

+ Public 
+ Opensource 
+ Introduce standards 
+ Same structure, libraries, and contracts 

## Access Control 

This tidbit is particularly interesting [https://docs.openzeppelin.com/contracts/4.x/access-control](https://docs.openzeppelin.com/contracts/4.x/access-control)

## How-to 

1. Create a new project with `npm init` and `truffle init` commands
2. Add contracts to project with `npm install @openzeppelin/contracts` 
3. You should now have `node_modules` directory under your token project 
4. Import the openzeppelin contracts you want to use 
5. run `truffle develop`,  `compile`, `migrate` *`migrate --reset` if you've run it before already 
6. let instance = await Token.deployed()  
7. Interact via console e.g `instance.symbol()`, `instance.balanceOf(accounts[0])`

## BN: 3e8 

BN = Big Number 

How to conver it to something human readable 

```javascript
let result = await instance.balanceOf(accounts[0])
result.toNumber()
result.toString() 
```

## Particularly powerful utility: Reentrancy Guard

Prevent a function from being entered again if it's already running by the same process. 

```javascript
modifier nonReentrant() { 
    require(_status != _ENTERED, "ReentrancyGuard: reentrant call"); 
    _status = _ENTERED; 
    _; 
    _status = _NOT_ENTERED; 
}
```

then you can just use that function like a modifier after importing it. 

## isContract() 

Make sure the address is a contract or a wallet 

## 7 OpenZeppelin Contracts You Should Always Use 

Full list [here](https://betterprogramming.pub/7-openzeppelin-contracts-you-should-always-use-5ba2e7953cc4)

1. Ownable 
2. Roles 
3. SafeMath 
4. SafeCast 
5. ERC20Detailed
6. ERC721Enumerable & ERC721Full 

```javascript 
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/drafts/Counters.sol";

contract GameItem is ERC721Full {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721Full("GameItem", "ITM") public {
    }

    function awardItem(address player, string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}
```

7. Address (check if contract)



