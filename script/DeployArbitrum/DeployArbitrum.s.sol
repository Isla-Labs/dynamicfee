// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Script } from "forge-std/Script.sol";
import { DynamicFeeEth } from "src/DynamicFeeEth.sol";
import { DynamicFeeUsd } from "src/DynamicFeeUsd.sol";

address constant CHAINLINK_ETH_USD_ARBITRUM = 0xAfF2135E3CE17578929C0ab714e2923f0C40b0DC; // Standard Proxy

contract DeployAll is Script {
    function run() external {
        vm.startBroadcast();
        new DynamicFeeEth();
        new DynamicFeeUsd(CHAINLINK_ETH_USD_ARBITRUM);
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
        DynamicFeeUsd feeUsd = new DynamicFeeUsd(CHAINLINK_ETH_USD_ARBITRUM);
        vm.stopBroadcast();
        return address(feeUsd);
    }
}
