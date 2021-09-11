//Contracts
const MyToken = artifacts.require("MyToken");

const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
  } = require('@openzeppelin/test-helpers')
  
  //track balance
  const balance = require('@openzeppelin/test-helpers/src/balance')
  
  // Main function that is executed during the test
  contract("MyToken", ([owner, alfa, beta, charlie]) => {
    // Global variable declarations
    let tokenInstance 

    //set contracts instances
    before(async function() {
        // Deploy AlienERC721 to testnet
        tokenInstance = await MyToken.deployed()
    })

    describe("ERC20", () => {

        it("1. get cap", async function (){
            const cap = await tokenInstance.cap()    
          })
        
        it("2. grant and renounce CAPPER_ROLE to accounts[1]", async function (){
            const capper_role =  await tokenInstance.CAPPER_ROLE()
            // newCapper 
            await tokenInstance.grantRole( capper_role, alfa)
            // renounce  
            await tokenInstance.renounceRole(capper_role, owner)
        })

        it("3. set new cap", async function (){
            const _newCap = (web3.utils.toWei('1000','ether'))
            // newCap 
            await tokenInstance.setCap( _newCap ,{from: alfa})
        })

        // Conditions that trigger a require statement can be precisely tested
        it("4. REVERT: contract owner will fail change cap, not capper_role (renounce it in test 2)", async function (){
            const _failCap = (web3.utils.toWei('10000','ether'))
            await expectRevert(
            tokenInstance.setCap(_failCap, {from: owner}),
            "setCap(): incorrect cap amount set, must be greater than zero"
            );
        })

    })// end describe

  })//end contract