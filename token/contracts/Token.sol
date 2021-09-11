// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol"; 

contract MyToken is Ownable, ERC20PresetMinterPauser {

    // Using ERC20PresetMinterPauser's roles {minter, pauser}
    bytes32 public constant CAPPER_ROLE = keccak256("CAPPER_ROLE");

    constructor() ERC20PresetMinterPauser("RandomCoin", "RC") {
        _cap = 1000;
        _setupRole(CAPPER_ROLE, _msgSender());
        _mint(msg.sender, 10);
    }

    using SafeMath for uint256;
    uint256 private _cap;

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        if (from == address(0)) {
            require(
                totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded"
            );
        }
    }

    // new function that allows you to modify the cap.
    function setCap(uint256 _newCap) public {
        require(
            hasRole(CAPPER_ROLE, _msgSender()),
            "ERC20PresetMinterPauser: must have capper role to change cap"
        );
        require(_newCap > 0, "ERC20Capped: cap is 0");
        _cap = _newCap;
    }
}
