// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library BoardLib {
    uint8 internal constant BOARD_SIZE = 64;

    /// @notice Reverts if the provided square is outside the 0-63 range.
    function assertSquare(uint8 square) internal pure {
        require(square < BOARD_SIZE, "board: invalid square");
    }

    /// @notice Encodes a move as a single bytes4 value.
    function encodeMove(uint8 fromSquare, uint8 toSquare, bytes2 extraData) internal pure returns (bytes4) {
        assertSquare(fromSquare);
        assertSquare(toSquare);
        return bytes4(abi.encodePacked(fromSquare, toSquare, extraData));
    }

    /// @notice Decodes an encoded move into its components.
    function decodeMove(bytes4 move) internal pure returns (uint8 fromSquare, uint8 toSquare, bytes2 extraData) {
        fromSquare = uint8(move[0]);
        toSquare = uint8(move[1]);
        extraData = bytes2(move << 16);
    }

    /// @notice Returns true if it's white's turn given move count.
    function isWhiteTurn(uint8 moveCount) internal pure returns (bool) {
        return moveCount % 2 == 0;
    }
}

