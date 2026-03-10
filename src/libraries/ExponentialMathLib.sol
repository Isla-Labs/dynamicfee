// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

/**
 * @title ExponentialMathLib
 * @notice Zero-dependency library for e^(-x/1000) with 18-decimal precision
 * @dev Uses Taylor series with range reduction. Input x in [0, 10000); output in 1e18 scale.
 * @author Isla Labs (Tom Jarvis | 0xBasti42)
 * @custom:security-contact security@islalabs.co
 */
library ExponentialMathLib {
    /// @dev 1e18 scale for fixed-point
    uint256 internal constant UNIT = 1e18;

    /// @dev Range reduction factor: e^(-x/1000) = (e^(-x/16000))^16
    uint256 internal constant RANGE_FACTOR = 16;

    /// @dev Number of Taylor terms (10 terms sufficient for |z| <= 0.625)
    uint256 internal constant TAYLOR_TERMS = 10;

    /**
     * @notice Calculate e^(-x/1000) with 18-decimal precision
     * @dev Range reduction: e^(-x/1000) = (e^(-x/16000))^16. Taylor series for e^z, z in [-0.625, 0].
     * @param x Unscaled exponent input, 0 <= x < 10000
     * @return value The 1e18-scaled result of e^(-x/1000)
     */
    function expNegXOver1000(uint256 x) internal pure returns (uint256 value) {
        if (x == 0) return UNIT;
        if (x >= 10_000) return 0;

        // Range reduction: z = x/16000, so e^(-x/1000) = (e^(-z))^16 = 1/(e^z)^16
        // Compute e^z for z = x/16000 in [0, 0.625], then result = 1e36 / (e^z)^16
        uint256 z = (x * UNIT) / (1000 * RANGE_FACTOR); // z in 1e18, max 0.625e18

        // Taylor series: e^z = 1 + z + z²/2! + z³/3! + ...
        uint256 t = _expTaylor(z);

        // t^16 via repeated squaring
        uint256 t2 = (t * t) / UNIT;
        uint256 t4 = (t2 * t2) / UNIT;
        uint256 t8 = (t4 * t4) / UNIT;
        uint256 t16 = (t8 * t8) / UNIT;

        // result = 1 / t16 in 1e18 scale
        return (UNIT * UNIT) / t16;
    }

    /**
     * @notice Taylor series for e^z, z in [0, 0.625e18] (1e18-scaled)
     * @dev e^z = 1 + z + z²/2! + z³/3! + ... + z^9/9!
     */
    function _expTaylor(uint256 z) internal pure returns (uint256) {
        uint256 sum = UNIT;
        uint256 term = z;

        for (uint256 i = 1; i < TAYLOR_TERMS; i++) {
            sum += term;
            term = (term * z) / UNIT / (i + 1);
        }
        sum += term;

        return sum;
    }
}
