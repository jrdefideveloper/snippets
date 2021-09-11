// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol"; 

contract MyToken is Ownable, ERC20PresetMinterPauser {

    bytes32 public constant CAPPER_ROLE = keccak256("CAPPER_ROLE");
    using SafeMath for uint256;
    uint256 private _cap;

    constructor() ERC20PresetMinterPauser("RandomCoin", "RC") {
        _cap = 1000;
        _setupRole(CAPPER_ROLE, _msgSender());
        _mint(msg.sender, 10);
    }

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        if (from == address(0)) {
            require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
        }
    }

    function setCap(uint256 _newCap) public {
        string memory setCapErrorMessage = "setCap(): must have CAPPER_ROLE to change cap"; 
        require(hasRole(CAPPER_ROLE, _msgSender()), setCapErrorMessage);
        string memory capMustBeGreaterThanZeroErrorMessage = "setCap(): incorrect cap amount set, must be greater than zero"; 
        require(_newCap > 0, capMustBeGreaterThanZeroErrorMessage);
        _cap = _newCap;
    }
}
