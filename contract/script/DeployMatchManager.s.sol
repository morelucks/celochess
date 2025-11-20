// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MatchManager} from "../src/match/MatchManager.sol";

contract DeployMatchManager is Script {
    function run() external returns (address) {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);
        MatchManager matchManager = new MatchManager();
        vm.stopBroadcast();

        console.log("MatchManager deployed at:", address(matchManager));
        console.log("Version:", matchManager.version());

        return address(matchManager);
    }
}
