// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IRSReserveVault is ERC4626 {
    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) ERC4626(_asset) {}

    // Optional: Add event-based tracking for incoming tax transfers
    event TaxReceived(address indexed from, uint256 amount);

    function depositTax(uint256 assets, address receiver) external returns (uint256 shares) {
        shares = deposit(assets, receiver);
        emit TaxReceived(msg.sender, assets);
    }
}
