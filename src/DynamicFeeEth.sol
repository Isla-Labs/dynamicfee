// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { DynamicFeeEth as BaseDynamicFeeEth } from "./base/DynamicFeeEth.sol";

/**
 * @title DynamicFeeEth
 * @notice Deployable wrapper for the abstract DynamicFeeEth base; ETH-denominated tiers, no oracle.
 */
contract DynamicFeeEth is BaseDynamicFeeEth { }
