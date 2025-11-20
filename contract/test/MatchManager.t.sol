// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MatchManager} from "../src/match/MatchManager.sol";

contract MatchManagerTest is Test {
    MatchManager manager;
    address player1 = address(0xA11CE);
    address player2 = address(0xB0B);

    bytes32 constant START_HASH = 0x3608f503d624b47779fba399a097e68bc35cdbd22fcf04e3d6b7a3bd8fa9b746; // random placeholder

    function setUp() public {
        manager = new MatchManager();
    }

    function testVersion() public view {
        assertEq(manager.version(), "0.2.0-skeleton");
    }

    function testCreateMatchRegistersCreator() public {
        vm.prank(player1);
        uint256 matchId =
            manager.createMatch(MatchManager.GameMode.PvP, MatchManager.PlayerColor.White, address(0), 0, START_HASH);

        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.white.account, player1);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.WaitingForPlayer));
    }

    function testJoinMatchActivatesGame() public {
        vm.prank(player1);
        uint256 matchId =
            manager.createMatch(MatchManager.GameMode.PvP, MatchManager.PlayerColor.White, address(0), 0, START_HASH);

        vm.prank(player2);
        manager.joinMatch(matchId);

        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.black.account, player2);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.Active));
    }

    function testSubmitMoveStoresBoardHash() public {
        vm.prank(player1);
        uint256 matchId =
            manager.createMatch(MatchManager.GameMode.PvP, MatchManager.PlayerColor.White, address(0), 0, START_HASH);
        vm.prank(player2);
        manager.joinMatch(matchId);

        bytes32 nextHash = 0x501a67fca04693e9e2615b46c3e0d19f8e8a7efb0f5d02d1a6c934f0988f84bc;

        vm.prank(player1);
        manager.submitMove(matchId, nextHash, bytes("e2e4"));

        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.board.fenHash, nextHash);
        assertEq(data.board.moveCount, 1);
    }

    function testFinishMatchSetsWinner() public {
        vm.prank(player1);
        uint256 matchId =
            manager.createMatch(MatchManager.GameMode.PvP, MatchManager.PlayerColor.White, address(0), 0, START_HASH);
        vm.prank(player2);
        manager.joinMatch(matchId);

        vm.prank(player1);
        manager.finishMatch(matchId, player1);

        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.winner, player1);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.Completed));
    }
}
