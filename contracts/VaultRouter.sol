VaultRouter(
  address _cryoVault,
  address _coolVault,
  address _heatVault,
  address _tokenAddress
)// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CryoVault.sol";
import "./CoolFlowVault.sol";
import "./HeatVault.sol";
import "./import/CoolFlowVault.sol";
contract VaultRouter is Ownable {
    IERC20 public immutable token;

    CryoVault public immutable cryoVault;
    CoolFlowVault public immutable coolVault;
    HeatVault public immutable heatVault;

    enum Tier { Cryo, Cool, Heat }

    mapping(address => mapping(Tier => uint256)) public userAllocations;

    event VaultRouted(address indexed user, Tier tier, uint256 amount);
    event VaultRebalanced(address indexed user, Tier fromTier, Tier toTier, uint256 amount);

    constructor(
        address _token,
        address _cryoVault,
        address _coolVault,
        address _heatVault
    ) {
        token = IERC20(_token);
        cryoVault = CryoVault(_cryoVault);
        coolVault = CoolFlowVault(_coolVault);
        heatVault = HeatVault(_heatVault);
    }

    function depositToTier(uint256 amount, Tier tier) external {
        require(amount > 0, "Amount must be greater than 0");

        token.transferFrom(msg.sender, address(this), amount);
        token.approve(getVault(tier), amount);

        if (tier == Tier.Cryo) {
            cryoVault.deposit(amount, msg.sender);
        } else if (tier == Tier.Cool) {
            coolVault.deposit(amount, msg.sender);
        } else if (tier == Tier.Heat) {
            heatVault.deposit(amount, msg.sender);
        }

        userAllocations[msg.sender][tier] += amount;
        emit VaultRouted(msg.sender, tier, amount);
    }

    function getVault(Tier tier) internal view returns (address) {
        if (tier == Tier.Cryo) return address(cryoVault);
        if (tier == Tier.Cool) return address(coolVault);
        return address(heatVault);
    }

    // Placeholder: Add rebalancing, sovereign logic, and operator integration here
}
