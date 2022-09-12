// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./ERC20.sol";
import "./Ownable.sol";

contract DisneyToken is ERC20, Ownable {
    constructor(address owner_, address tokenTo_, uint256 initialTotalSupply_) ERC20("DisneyCoin", "DC")
    {
        _transferOwnership(owner_);
        _mint(tokenTo_, initialTotalSupply_);
    }

    function decimals() public pure override returns (uint8) {
        return 2;
    }

    function mint(address account_, uint256 amount_) external onlyOwner {
        require(account_ != address(0), "ERROR: is not accepted zero address to mint");
        require(amount_ > 0, "ERROR: is not accepted zero amount to mint");
        _mint(account_, amount_);
    }

    function burn(address account_, uint256 amount_) external onlyOwner {
        require(account_ != address(0), "ERROR: is not accepted zero address to burn");
        require(amount_ > 0, "ERROR: is not accepted zero amount to burn");
        _burn(account_, amount_);
    }

    function transferToDisney(address owner_, address spender_, uint256 amount_) external {
        require(amount_ <= balanceOf(owner_), "ERROR: Your token balance is less than the price to pay");
        _approve(owner_, spender_, amount_);
        transferFrom(owner_, spender_, amount_);
    }
}