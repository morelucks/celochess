// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MatchManager} from "../src/match/MatchManager.sol";

contract MockERC20 {
    string public name = "Mock";
    string public symbol = "MOCK";
    uint8 public decimals = 18;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "allowance");
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(balanceOf[from] >= amount, "balance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}

contract MatchManagerTest is Test {
    MatchManager manager;
    MockERC20 token;

    address player1 = address(0xA11CE);
    address player2 = address(0xB0B);

    uint256 constant STAKE = 1e18;
    bytes32 constant START_HASH = 0x3608f503d624b47779fba399a097e68bc35cdbd22fcf04e3d6b7a3bd8fa9b746;

    function setUp() public {
        manager = new MatchManager();
        token = new MockERC20();

        token.mint(player1, 10 * STAKE);
        token.mint(player2, 10 * STAKE);
    }

    function testVersion() public view {
        assertEq(manager.version(), "0.3.0-escrow");
    }

    function testCreateMatchCollectsStake() public {
        vm.startPrank(player1);
        token.approve(address(manager), STAKE);
        uint256 matchId = manager.createMatch(
            MatchManager.GameMode.PvP, MatchManager.PlayerColor.White, address(token), STAKE, START_HASH
        );
        vm.stopPrank();

        assertEq(token.balanceOf(address(manager)), STAKE);
        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.pot, STAKE);
        assertTrue(data.white.escrowed);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.WaitingForPlayer));
    }

    function testJoinMatchCollectsStakeAndStarts() public {
        uint256 matchId = _createMatch();

        vm.startPrank(player2);
        token.approve(address(manager), STAKE);
        manager.joinMatch(matchId);
        vm.stopPrank();

        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.pot, 2 * STAKE);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.Active));
        assertTrue(data.black.escrowed);
    }

    function testFinishMatchPaysWinner() public {
        uint256 matchId = _readyMatch();
        uint256 balanceBefore = token.balanceOf(player1);

        vm.prank(player1);
        manager.finishMatch(matchId, player1);

        assertEq(token.balanceOf(player1), balanceBefore + 2 * STAKE);
        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.pot, 0);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.Completed));
    }

    function testCancelMatchRefundsCreator() public {
        uint256 matchId = _createMatch();
        uint256 balanceBefore = token.balanceOf(player1);

        vm.prank(player1);
        manager.cancelMatch(matchId);

        assertEq(token.balanceOf(player1), balanceBefore + STAKE);
        MatchManager.Match memory data = manager.getMatch(matchId);
        assertEq(data.pot, 0);
        assertEq(uint256(data.status), uint256(MatchManager.MatchStatus.Cancelled));
    }

    function testSubmitMoveRequiresActive() public {
        uint256 matchId = _createMatch();
        vm.expectRevert("match: inactive");
        vm.prank(player1);
        manager.submitMove(matchId, bytes32(uint256(1)), bytes("e2e4"));
    }

    function _createMatch() internal returns (uint256 matchId) {
        vm.startPrank(player1);
        token.approve(address(manager), STAKE);
        matchId = manager.createMatch(
            MatchManager.GameMode.PvP, MatchManager.PlayerColor.White, address(token), STAKE, START_HASH
        );
        vm.stopPrank();
    }

    function _readyMatch() internal returns (uint256 matchId) {
        matchId = _createMatch();
        vm.startPrank(player2);
        token.approve(address(manager), STAKE);
        manager.joinMatch(matchId);
        vm.stopPrank();
    }
}
