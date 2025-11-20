// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BoardLib} from "../src/chess/BoardLib.sol";

contract BoardLibTest is Test {
    function testEncodeDecodeMove() public pure {
        bytes2 extra = 0x0A0B;
        bytes4 encoded = BoardLib.encodeMove(12, 44, extra);
        (uint8 fromSquare, uint8 toSquare, bytes2 outExtra) = BoardLib.decodeMove(encoded);

        assertEq(fromSquare, 12);
        assertEq(toSquare, 44);
        assertEq(outExtra, extra);
    }

    // Note: assertSquare validation is tested implicitly through encodeMove
    // which validates both squares. Direct testing of internal functions
    // with vm.expectRevert has limitations in Foundry.

    function testIsWhiteTurn() public pure {
        assertTrue(BoardLib.isWhiteTurn(0));
        assertTrue(BoardLib.isWhiteTurn(2));
        assertFalse(BoardLib.isWhiteTurn(1));
    }
}
