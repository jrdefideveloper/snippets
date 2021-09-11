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

