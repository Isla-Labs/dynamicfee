// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Script } from "forge-std/Script.sol";
import { DynamicFeeEth } from "src/DynamicFeeEth.sol";
import { DynamicFeeUsd } from "src/DynamicFeeUsd.sol";

address constant CHAINLINK_ETH_USD_ETHEREUM = 0xd82562bb17557231Cd871e1B2525F3AB8d63D409; // Standard Proxy

contract DeployAll is Script {
    function run() external {
        vm.startBroadcast();
        new DynamicFeeEth();
        new DynamicFeeUsd(CHAINLINK_ETH_USD_ETHEREUM);
        vm.stopBroadcast();
    }
}

contract DeployExponentialMathLib is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        address expLib = deployCode("src/libraries/ExponentialMathLib.sol:ExponentialMathLib");
        vm.stopBroadcast();
        return expLib;
    }
}

contract DeployDynamicFeeLib is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        address feeLib = deployCode("src/DynamicFeeLib.sol:DynamicFeeLib");
        vm.stopBroadcast();
        return feeLib;
    }
}

contract DeployDynamicFeeEth is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        DynamicFeeEth feeEth = new DynamicFeeEth();
        vm.stopBroadcast();
        return address(feeEth);
    }
}

contract DeployDynamicFeeUsd is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        DynamicFeeUsd feeUsd = new DynamicFeeUsd(CHAINLINK_ETH_USD_ETHEREUM);
        vm.stopBroadcast();
        return address(feeUsd);
    }
}
