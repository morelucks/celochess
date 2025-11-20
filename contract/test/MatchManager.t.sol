// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MatchManager} from "../src/match/MatchManager.sol";

contract MatchManagerTest is Test {
    MatchManager manager;

    function setUp() public {
        manager = new MatchManager();
    }

    function testVersion() public view {
        assertEq(manager.version(), "0.0.1-scaffold");
    }
}
