// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Script } from "forge-std/Script.sol";

address constant CHAINLINK_ETH_USD_BASE_SEPOLIA = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;

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
        address feeEth = deployCode("src/DynamicFeeEth.sol:DynamicFeeEth");
        vm.stopBroadcast();
        return feeEth;
    }
}

contract DeployDynamicFeeUsd is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        address feeUsd = deployCode("src/DynamicFeeUsd.sol:DynamicFeeUsd", abi.encode(CHAINLINK_ETH_USD_BASE_SEPOLIA));
        vm.stopBroadcast();
        return feeUsd;
    }
}
