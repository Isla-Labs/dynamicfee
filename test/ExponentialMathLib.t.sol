// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Test} from "forge-std/Test.sol";
import {ExponentialMathLib} from "../src/libraries/ExponentialMathLib.sol";

contract ExponentialMathLibTest is Test {
    /// @dev Tolerance: 1e14 (0.0001% of 1e18) - Taylor approximation may have small error
    uint256 constant TOLERANCE = 1e14;

    function test_expNegXOver1000_zero() public pure {
        assertEq(ExponentialMathLib.expNegXOver1000(0), 1e18);
    }

    function test_expNegXOver1000_clamp() public pure {
        assertEq(ExponentialMathLib.expNegXOver1000(10_000), 0);
        assertEq(ExponentialMathLib.expNegXOver1000(99_999), 0);
    }

    /// @dev Test against precomputed known values of e^(-x/1000) (1e18 scale)
    function test_expNegXOver1000_knownValues() public pure {
        // e^(-0/1000) = 1
        assertEq(ExponentialMathLib.expNegXOver1000(0), 1e18);
        // e^(-1/1000) ≈ 0.999000499...
        assertApproxEqAbs(ExponentialMathLib.expNegXOver1000(1), 999_000_499_333_222_084, TOLERANCE);
        // e^(-100/1000) = e^(-0.1) ≈ 0.904837418...
        assertApproxEqAbs(ExponentialMathLib.expNegXOver1000(100), 904_837_418_035_959_573, TOLERANCE);
        // e^(-500/1000) = e^(-0.5) ≈ 0.606530659...
        assertApproxEqAbs(ExponentialMathLib.expNegXOver1000(500), 606_530_659_712_633_423, TOLERANCE);
        // e^(-1000/1000) = e^(-1) ≈ 0.367879441...
        assertApproxEqAbs(ExponentialMathLib.expNegXOver1000(1000), 367_879_441_171_442_321, TOLERANCE);
        // e^(-5000/1000) = e^(-5) ≈ 0.006737947 (6.737e15 in 1e18 scale)
        assertApproxEqAbs(ExponentialMathLib.expNegXOver1000(5000), 6_737_946_999_091_098, TOLERANCE);
    }

    /// @dev Monotonicity: e^(-x/1000) must decrease as x increases
    function test_expNegXOver1000_monotonicity() public pure {
        uint256[] memory inputs = _inputs();
        uint256 prev = 1e18 + 1; // start above max
        for (uint256 i = 0; i < inputs.length; i++) {
            uint256 x = inputs[i];
            uint256 result = ExponentialMathLib.expNegXOver1000(x);
            assertLe(result, prev, "must be monotonically decreasing");
            prev = result;
        }
    }

    /// @dev Output bounds: result must be in [0, 1e18]
    function test_expNegXOver1000_bounds() public pure {
        for (uint256 x = 0; x <= 10_000; x += 100) {
            uint256 result = ExponentialMathLib.expNegXOver1000(x);
            assertLe(result, 1e18, "x");
            assertGe(result, 0, "x");
        }
    }

    function _inputs() internal pure returns (uint256[] memory) {
        uint256[] memory ins = new uint256[](15);
        ins[0] = 1;
        ins[1] = 10;
        ins[2] = 50;
        ins[3] = 100;
        ins[4] = 250;
        ins[5] = 500;
        ins[6] = 1000;
        ins[7] = 2000;
        ins[8] = 2500;
        ins[9] = 3000;
        ins[10] = 5000;
        ins[11] = 7000;
        ins[12] = 7500;
        ins[13] = 9000;
        ins[14] = 9999;
        return ins;
    }
}
