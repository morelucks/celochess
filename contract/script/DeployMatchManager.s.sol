// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MatchManager} from "../src/match/MatchManager.sol";

contract DeployMatchManager is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        new MatchManager();
        vm.stopBroadcast();
    }
}
