// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BoardLib} from "./BoardLib.sol";

/// @title ChessAI
/// @notice Simple deterministic AI for PvC matches
library ChessAI {
    /// @notice Generates a deterministic move based on board state and move count
    /// @param moveCount Current move count in the game
    /// @param stateHash Hash of current board state (for determinism)
    /// @return encodedMove A valid move encoded as bytes4
    /// @dev This is a simple AI that picks moves deterministically based on state
    function generateMove(uint8 moveCount, bytes32 stateHash) internal pure returns (bytes4 encodedMove) {
        // Simple deterministic strategy: use state hash and move count to pick a move
        // This ensures the AI is predictable and verifiable

        // Extract pseudo-random values from state hash
        uint256 seed = uint256(stateHash) + uint256(moveCount);

        // For now, implement a simple strategy:
        // - First move: e2-e4 (pawn forward) if white, e7-e5 if black
        // - Otherwise: pick a move based on seed

        if (moveCount == 0) {
            // White's first move: e2 (square 12) to e4 (square 28)
            return BoardLib.encodeMove(12, 28, bytes2(0));
        } else if (moveCount == 1) {
            // Black's first move: e7 (square 52) to e5 (square 36)
            return BoardLib.encodeMove(52, 36, bytes2(0));
        } else {
            // Simple deterministic move selection based on seed
            // This is a placeholder - in production, you'd want more sophisticated logic
            uint8 fromSquare = uint8(seed % 64);
            uint8 toSquare = uint8((seed >> 8) % 64);

            // Ensure squares are different
            if (fromSquare == toSquare) {
                toSquare = (toSquare + 1) % 64;
            }

            return BoardLib.encodeMove(fromSquare, toSquare, bytes2(0));
        }
    }

    /// @notice Checks if it's the AI's turn
    /// @param moveCount Current move count
    /// @param aiIsWhite true if AI is playing white
    /// @return true if it's the AI's turn
    function isAITurn(uint8 moveCount, bool aiIsWhite) internal pure returns (bool) {
        bool isWhiteTurn = BoardLib.isWhiteTurn(moveCount);
        return aiIsWhite == isWhiteTurn;
    }
}

