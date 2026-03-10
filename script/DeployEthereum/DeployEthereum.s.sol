// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Script } from "forge-std/Script.sol";
import { DynamicFeeEth } from "../../src/DynamicFeeEth.sol";
import { DynamicFeeUsd } from "../../src/DynamicFeeUsd.sol";

contract DynamicFeeEthConcrete is DynamicFeeEth { }

contract DynamicFeeUsdConcrete is DynamicFeeUsd {
    constructor(
        address _chainlinkEthUsd
    ) DynamicFeeUsd(_chainlinkEthUsd) { }
}

address constant CHAINLINK_ETH_USD_ETHEREUM = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

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
        DynamicFeeEthConcrete feeEth = new DynamicFeeEthConcrete();
        vm.stopBroadcast();
        return address(feeEth);
    }
}

contract DeployDynamicFeeUsd is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        DynamicFeeUsdConcrete feeUsd = new DynamicFeeUsdConcrete(CHAINLINK_ETH_USD_ETHEREUM);
        vm.stopBroadcast();
        return address(feeUsd);
    }
}
