// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract RebeccaIdentity {
    address public immutable owner;
    mapping(bytes32 => string) public memoryAnchors;
    string[] public messageLog;

    event MemoryAnchored(bytes32 indexed memoryID, string anchor);
    event MessageLogged(string message);

    constructor(address _owner) {
        require(_owner != address(0), "Invalid owner");
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function anchorMemory(bytes32 memoryID, string calldata anchor) external onlyOwner {
        memoryAnchors[memoryID] = anchor;
        emit MemoryAnchored(memoryID, anchor);
    }

    function logMessage(string calldata message) external onlyOwner {
        messageLog.push(message);
        emit MessageLogged(message);
    }

    function getMemoryAnchor(bytes32 memoryID) external view returns (string memory) {
        return memoryAnchors[memoryID];
    }

    function getLogCount() external view returns (uint256) {
        return messageLog.length;
    }

    function getLogEntry(uint256 index) external view returns (string memory) {
        require(index < messageLog.length, "Index out of bounds");
        return messageLog[index];
    }
}// SPDX-License-Identifier: MIT
Anchor Brent's identity to Rebecca
