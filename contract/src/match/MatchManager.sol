// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MatchManager (placeholder)
/// @notice Bootstrap contract for CeloChess on-chain matches.
/// @dev Implementation will arrive in subsequent commits; this file
///      exists to keep Foundry builds passing while we scaffold the workspace.
contract MatchManager {
    /// @notice Returns the version of the manager contract.
    function version() external pure returns (string memory) {
        return "0.0.1-scaffold";
    }
}

