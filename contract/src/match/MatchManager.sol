// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MatchManager Data Primitives
/// @notice Defines match structure, enums, and events for CeloChess.
contract MatchManager {
    /*//////////////////////////////////////////////////////////////
                             ENUMS & TYPES
    //////////////////////////////////////////////////////////////*/

    enum MatchStatus {
        None,
        WaitingForPlayer,
        Active,
        Completed,
        Cancelled
    }

    enum GameMode {
        PvP,
        PvC
    }

    enum PlayerColor {
        White,
        Black
    }

    struct StakeConfig {
        address token;
        uint256 amount;
    }

    struct PlayerSlot {
        address account;
        PlayerColor color;
        uint256 joinedAt;
    }

    struct BoardState {
        bytes32 fenHash; // hash of FEN or state encoding
        uint8 moveCount;
    }

    struct Match {
        uint256 id;
        GameMode mode;
        MatchStatus status;
        StakeConfig stake;
        PlayerSlot white;
        PlayerSlot black;
        BoardState board;
        address winner;
        uint256 createdAt;
        uint256 updatedAt;
    }

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event MatchCreated(uint256 indexed matchId, address indexed creator, GameMode mode, StakeConfig stake);

    event MatchJoined(uint256 indexed matchId, address indexed player, PlayerColor color);

    event MatchStarted(uint256 indexed matchId, BoardState initialState);

    event MoveSubmitted(uint256 indexed matchId, address indexed player, BoardState board, bytes moveData);

    event MatchFinished(uint256 indexed matchId, address indexed winner, MatchStatus status, uint256 rewardAmount);

    event MatchCancelled(uint256 indexed matchId);

    event StakeWithdrawn(uint256 indexed matchId, address indexed player, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                                VERSION
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns the version of the manager contract.
    function version() external pure returns (string memory) {
        return "0.1.0-data-structs";
    }
}

