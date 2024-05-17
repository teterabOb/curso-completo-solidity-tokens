// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console2, console} from "forge-std/Script.sol";
import {ObserversToken} from "../src/ObserversToken.sol";

contract ObserversTokenScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        vm.startBroadcast(deployerPrivateKey);
        ObserversToken token = new ObserversToken(address(this));
        console.logAddress(token.owner());
        vm.stopBroadcast();
    }
}
