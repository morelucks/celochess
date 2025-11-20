// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title MatchManager Data Primitives
/// @notice Defines match structure, enums, and events for CeloChess.
contract MatchManager {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public nextMatchId = 1;
    mapping(uint256 => Match) internal matches;
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
                                ACTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Creates a match and places msg.sender in the requested color slot.
    function createMatch(
        GameMode mode,
        PlayerColor creatorColor,
        address stakeToken,
        uint256 stakeAmount,
        bytes32 initialStateHash
    ) external returns (uint256 matchId) {
        matchId = nextMatchId++;

        Match storage matchRef = matches[matchId];
        matchRef.id = matchId;
        matchRef.mode = mode;
        matchRef.status = MatchStatus.WaitingForPlayer;
        matchRef.createdAt = block.timestamp;
        matchRef.updatedAt = block.timestamp;
        matchRef.stake = StakeConfig(stakeToken, stakeAmount);
        matchRef.board = BoardState({fenHash: initialStateHash, moveCount: 0});

        PlayerSlot memory slot = PlayerSlot({account: msg.sender, color: creatorColor, joinedAt: block.timestamp});

        if (creatorColor == PlayerColor.White) {
            matchRef.white = slot;
        } else {
            matchRef.black = slot;
        }

        emit MatchCreated(matchId, msg.sender, mode, matchRef.stake);
    }

    /// @notice Allows another player to join an open match.
    function joinMatch(uint256 matchId) external {
        Match storage matchRef = _requireMatch(matchId);
        require(matchRef.status == MatchStatus.WaitingForPlayer, "match: not open");

        if (matchRef.white.account == address(0)) {
            matchRef.white = PlayerSlot(msg.sender, PlayerColor.White, block.timestamp);
            emit MatchJoined(matchId, msg.sender, PlayerColor.White);
        } else if (matchRef.black.account == address(0)) {
            matchRef.black = PlayerSlot(msg.sender, PlayerColor.Black, block.timestamp);
            emit MatchJoined(matchId, msg.sender, PlayerColor.Black);
        } else {
            revert("match: already full");
        }

        if (matchRef.white.account != address(0) && matchRef.black.account != address(0)) {
            matchRef.status = MatchStatus.Active;
            matchRef.updatedAt = block.timestamp;
            emit MatchStarted(matchId, matchRef.board);
        }
    }

    /// @notice Submits a move updating the board hash (validation TBD).
    function submitMove(uint256 matchId, bytes32 newStateHash, bytes calldata moveData) external {
        Match storage matchRef = _requireMatch(matchId);
        require(matchRef.status == MatchStatus.Active, "match: inactive");
        require(msg.sender == matchRef.white.account || msg.sender == matchRef.black.account, "match: not player");

        matchRef.board = BoardState({fenHash: newStateHash, moveCount: matchRef.board.moveCount + 1});
        matchRef.updatedAt = block.timestamp;

        emit MoveSubmitted(matchId, msg.sender, matchRef.board, moveData);
    }

    /// @notice Marks a match as finished and records the winner (no payouts yet).
    function finishMatch(uint256 matchId, address winner) external {
        Match storage matchRef = _requireMatch(matchId);
        require(matchRef.status == MatchStatus.Active, "match: not active");
        require(winner == matchRef.white.account || winner == matchRef.black.account, "match: invalid winner");

        matchRef.status = MatchStatus.Completed;
        matchRef.winner = winner;
        matchRef.updatedAt = block.timestamp;

        emit MatchFinished(matchId, winner, MatchStatus.Completed, 0);
    }

    /// @notice Returns match metadata.
    function getMatch(uint256 matchId) external view returns (Match memory) {
        return matches[matchId];
    }

    /// @notice Returns the version of the manager contract.
    function version() external pure returns (string memory) {
        return "0.2.0-skeleton";
    }

    /*//////////////////////////////////////////////////////////////
                              INTERNALS
    //////////////////////////////////////////////////////////////*/

    function _requireMatch(uint256 matchId) internal view returns (Match storage matchRef) {
        matchRef = matches[matchId];
        require(matchRef.id != 0, "match: invalid id");
    }
}

