// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { DynamicFeeUsd as BaseDynamicFeeUsd } from "./base/DynamicFeeUsd.sol";

/**
 * @title DynamicFeeUsd
 * @notice Deployable wrapper for the abstract DynamicFeeUsd base; USD-denominated tiers via Chainlink.
 * @dev Constructor takes Chainlink ETH/USD price feed address (network-specific).
 */
contract DynamicFeeUsd is BaseDynamicFeeUsd {
    constructor(
        address _chainlinkEthUsd
    ) BaseDynamicFeeUsd(_chainlinkEthUsd) { }
}
