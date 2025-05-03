// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract OperatorRelay {
    address public immutable owner;
    mapping(string => bytes32) public triggerHashes;

    event TriggerExecuted(string command, address executor);
    event TriggerHashUpdated(string command, bytes32 newHash);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Register or update an expected command trigger (e.g., CryoDeposit, RebalanceCool)
    function updateTriggerHash(string calldata command, bytes32 hash) external onlyOwner {
        triggerHashes[command] = hash;
        emit TriggerHashUpdated(command, hash);
    }

    // Execute a command by verifying its hash
    function executeCommand(string calldata command, bytes calldata payload) external {
        require(keccak256(payload) == triggerHashes[command], "Invalid payload for command");
        emit TriggerExecuted(command, msg.sender);
        // Forward to external system (off-chain AI listener or another contract call)
        // This is where LangChain or Slack Agent picks up the event
    }

    // View command hash for off-chain coordination
    function getCommandHash(string calldata command) external view returns (bytes32) {
        return triggerHashes[command];
    }
}Enable Operator to execute secure, hash-verified vault actions (Slack + LangChain)
