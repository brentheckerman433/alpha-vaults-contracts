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
}// Adjustable tax rate in basis points (e.g., 200 = 2.00%)
uint256 public taxRate = 200;
bool public taxRateLocked = false;

// Modifier to restrict to future governance or multisig (placeholder)
modifier onlyAdmin() {
    require(msg.sender == address(0xYourAdminWalletHere), "Not authorized");
    _;
}

// Set a new tax rate (only allowed if not locked)
function setTaxRate(uint256 newRate) external onlyAdmin {
    require(!taxRateLocked, "Tax rate is locked");
    require(newRate <= 1000, "Max 10%"); // safety limit
    taxRate = newRate;
}

// Lock the current tax rate permanently
function lockTaxRate() external onlyAdmin {
    taxRateLocked = true;
}

