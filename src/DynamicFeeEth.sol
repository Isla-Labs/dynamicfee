// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

/**
 * ─── Formula
 *
 *     ϕ(v) = f_min + (ϕ_start - f_min) ⋅ e^(−α ⋅ (v−v_start) / κ)
 *
 * ─── Variables
 *
 *     - ϕ: The calculated fee rate (output, in basis points)
 *     - v: Transaction volume (input, in ETH wei)
 *     - f_min: Minimum fee floor (1% = 100 bps)
 *     - v_start: Starting volume threshold for the current tier (ETH wei)
 *     - ϕ_start: Initial fee value for the current tier (bps)
 *     - α: Decay factor for the current tier
 *     - e: Euler's number
 *     - κ: Scale parameter (1000)
 *
 * ─── Design
 *
 *     The fee rate decays exponentially as transaction volume increases. This decay happens within four
 *     predefined tiers (v_start) that each have their own decay factor (α) and stepwise function (ϕ_start).
 *
 *     Each tier's variables (v_start, ϕ_start, α) are predefined; f_min, e, and κ are constants. The only
 *     variable input is transaction volume (v) for calculating the final fee rate (ϕ) output.
 *
 * ─── ETH Terms
 *
 *     Tiers are denominated in ETH (not USD). No oracle required.
 *
 * ─── Fee Bounds
 *
 *     - Maximum: 2.00% for low volume transactions
 *     - Minimum: 0.60% for high volume transactions
 *     - Scale parameter κ: always 1000
 *
 * ─── Tiers
 *
 *     Four tiers apply at different volume thresholds (0, 2 ETH, 20 ETH, 200 ETH in the placeholder examples).
 *     Each tier's decay factor (α) determines how quickly the fee rate declines as transaction volume increases.
 *
 */

import { ExponentialMathLib } from "./libraries/ExponentialMathLib.sol";

/**
 * @title DynamicFeeEth
 * @notice Abstract contract for dynamic fee calculation in ETH terms; no oracle, uses ExponentialMathLib
 * @dev Tiers are in ETH. All parameters are configurable; base version uses placeholders.
 * @dev FEE_START is the output at the beginning of each tier
 * @dev ALPHA_TIER is configurable decay factor for each tier (higher being faster decline)
 * @dev TIER is transaction volume threshold (starting at zero for clarity)
 * @author Isla Labs (Tom Jarvis | 0xBasti42)
 * @custom:security-contact security@islalabs.co
 */
abstract contract DynamicFeeEth {
    uint256 internal constant ETH_DECIMALS = 1e18;

    // ------------------------------------------
    //  Dynamic Fee Constants
    // ------------------------------------------

    uint256 internal constant FEE_MIN_BPS = 60;

    uint256 internal constant FEE_START_TIER_1 = 200;
    uint256 internal constant FEE_START_TIER_2 = 136;
    uint256 internal constant FEE_START_TIER_3 = 90;
    uint256 internal constant FEE_START_TIER_4 = 60;

    uint256 internal constant ALPHA_TIER_1 = 300_000; // scaled for ETH
    uint256 internal constant ALPHA_TIER_2 = 50_000;
    uint256 internal constant ALPHA_TIER_3 = 100_000;
    uint256 internal constant ALPHA_TIER_4 = 300_000;

    uint256 internal constant TIER_1_THRESHOLD_ETH = 0;
    uint256 internal constant TIER_2_THRESHOLD_ETH = 2e18; // 2 ETH
    uint256 internal constant TIER_3_THRESHOLD_ETH = 20e18; // 20 ETH
    uint256 internal constant TIER_4_THRESHOLD_ETH = 200e18; // 200 ETH

    uint256 internal constant SCALE_PARAMETER = 1000;

    // ------------------------------------------
    //  Fee Calculation
    // ------------------------------------------

    /**
     * @notice Dynamic fee with exponential decay
     * @param volumeEth Volume in ETH (wei)
     * @return feeBps Fee in basis points
     */
    function calculateDynamicFee(uint256 volumeEth) public pure returns (uint256 feeBps) {
        (uint256 alpha, uint256 vStartEth, uint256 feeStart) = _getTierParameters(volumeEth);

        uint256 volumeDiff = volumeEth > vStartEth ? (volumeEth - vStartEth) / ETH_DECIMALS : 0;

        uint256 exponent = (alpha * volumeDiff) / SCALE_PARAMETER;
        uint256 expValue = _calculateExponentialDecay(exponent);

        uint256 feeRange = feeStart - FEE_MIN_BPS;
        uint256 dynamicComponent = (feeRange * expValue) / 1 ether;

        uint256 result = FEE_MIN_BPS + dynamicComponent;
        return result < FEE_MIN_BPS ? FEE_MIN_BPS : result;
    }

    // ------------------------------------------
    //  Internal
    // ------------------------------------------

    /**
     * @notice Get tier parameters based on ETH volume
     * @dev Returns static variables from cache so that volume (v) is the only dynamic input
     * @param volumeEth Volume in ETH (wei)
     * @return alpha Decay factor for fee tier
     * @return vStartEth Starting volume threshold for fee tier
     * @return feeStart Precomputed fee (bps) at v_start for fee tier
     */
    function _getTierParameters(uint256 volumeEth)
        internal
        pure
        returns (uint256 alpha, uint256 vStartEth, uint256 feeStart)
    {
        if (volumeEth <= TIER_2_THRESHOLD_ETH) return (ALPHA_TIER_1, TIER_1_THRESHOLD_ETH, FEE_START_TIER_1);
        if (volumeEth <= TIER_3_THRESHOLD_ETH) return (ALPHA_TIER_2, TIER_2_THRESHOLD_ETH, FEE_START_TIER_2);
        if (volumeEth <= TIER_4_THRESHOLD_ETH) return (ALPHA_TIER_3, TIER_3_THRESHOLD_ETH, FEE_START_TIER_3);
        return (ALPHA_TIER_4, TIER_4_THRESHOLD_ETH, FEE_START_TIER_4);
    }

    /**
     * @notice Calculate e^(-x/1000) with 18-decimal precision
     * @dev Uses ExponentialMathLib (zero-dependency Taylor + range reduction)
     * @param x Unscaled exponent input
     * @return value The 1e18-scaled result of e^(-x/1000)
     */
    function _calculateExponentialDecay(uint256 x) internal pure returns (uint256 value) {
        return ExponentialMathLib.expNegXOver1000(x);
    }
}
