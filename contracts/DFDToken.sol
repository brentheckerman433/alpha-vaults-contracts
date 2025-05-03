Deploy DFDToken with tax-routing logic to IRSReserveVault// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DFDToken is ERC20, Ownable {
    address public immutable irsReserveVault;

    mapping(address => bool) public isTaxExempt;

    event TaxRouted(address indexed from, uint256 taxAmount);
    event ExemptAdded(address indexed user);
    event ExemptRemoved(address indexed user);

    constructor(address _irsReserveVault) ERC20("DeFi the Dollar", "DFD") {
        irsReserveVault = _irsReserveVault;
        _mint(msg.sender, 1_000_000 * 10**decimals()); // 1 million initial supply
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (isTaxExempt[from] || isTaxExempt[to]) {
            super._transfer(from, to, amount);
        } else {
            uint256 tax = (amount * 2) / 100; // 2% tax
            uint256 net = amount - tax;
            super._transfer(from, irsReserveVault, tax);
            emit TaxRouted(from, tax);
            super._transfer(from, to, net);
        }
    }

    function addTaxExempt(address user) external onlyOwner {
        isTaxExempt[user] = true;
        emit ExemptAdded(user);
    }

    function removeTaxExempt(address user) external onlyOwner {
        isTaxExempt[user] = false;
        emit ExemptRemoved(user);
    }
}
