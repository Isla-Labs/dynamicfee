// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Test } from "forge-std/Test.sol";
import { DynamicFeeLib } from "../src/DynamicFeeLib.sol";
import { DynamicFeeEth } from "../src/DynamicFeeEth.sol";

contract DynamicFeeLibHarness {
    function calculateDynamicFee(uint256 volumeEth) external pure returns (uint256) {
        return DynamicFeeLib.calculateDynamicFee(volumeEth);
    }
}

contract DynamicFeeEthHarness is DynamicFeeEth { }

contract DynamicFeeLibTest is Test {
    DynamicFeeLibHarness harness;

    uint256 constant FEE_MIN_BPS = 60;
    uint256 constant FEE_MAX_BPS = 200;

    function setUp() public {
        harness = new DynamicFeeLibHarness();
    }

    // ------------------------------------------
    //  Fee Bounds
    // ------------------------------------------

    function test_feeBounds_zeroVolume() public pure {
        uint256 fee = DynamicFeeLib.calculateDynamicFee(0);
        assertGe(fee, FEE_MIN_BPS, "min");
        assertLe(fee, FEE_MAX_BPS, "max");
        assertEq(fee, 200, "zero volume should start at 2%");
    }

    function test_feeBounds_lowVolume() public pure {
        uint256 fee = DynamicFeeLib.calculateDynamicFee(1 ether);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    function test_feeBounds_highVolume() public pure {
        uint256 fee = DynamicFeeLib.calculateDynamicFee(10_000 ether);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    function test_feeBounds_extremeVolume() public pure {
        uint256 fee = DynamicFeeLib.calculateDynamicFee(1_000_000 ether);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    function test_feeBounds_fuzz(uint256 volumeEth) public pure {
        volumeEth = bound(volumeEth, 0, 10_000_000 ether);
        uint256 fee = DynamicFeeLib.calculateDynamicFee(volumeEth);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    // ------------------------------------------
    //  Monotonicity (higher volume = lower fee)
    // ------------------------------------------

    function test_monotonicity() public pure {
        uint256 fee1 = DynamicFeeLib.calculateDynamicFee(0);
        uint256 fee2 = DynamicFeeLib.calculateDynamicFee(1 ether);
        uint256 fee3 = DynamicFeeLib.calculateDynamicFee(10 ether);
        uint256 fee4 = DynamicFeeLib.calculateDynamicFee(100 ether);
        uint256 fee5 = DynamicFeeLib.calculateDynamicFee(1000 ether);
        uint256 fee6 = DynamicFeeLib.calculateDynamicFee(10_000 ether);

        assertGe(fee1, fee2);
        assertGe(fee2, fee3);
        assertGe(fee3, fee4);
        assertGe(fee4, fee5);
        assertGe(fee5, fee6);
    }

    function test_monotonicity_fuzz(uint256 v1, uint256 v2) public pure {
        v1 = bound(v1, 0, 1_000_000 ether);
        v2 = bound(v2, 0, 1_000_000 ether);
        if (v1 < v2) {
            uint256 fee1 = DynamicFeeLib.calculateDynamicFee(v1);
            uint256 fee2 = DynamicFeeLib.calculateDynamicFee(v2);
            assertGe(fee1, fee2);
        }
    }

    // ------------------------------------------
    //  Tier Boundaries (0, 2, 20, 200 ETH)
    // ------------------------------------------

    function test_tier1_atZero() public pure {
        uint256 fee = DynamicFeeLib.calculateDynamicFee(0);
        assertEq(fee, 200, "Tier 1 start: 2%");
    }

    /// @dev Tier 2 (2–20 ETH): within-tier decay
    function test_tier2_withinTierDecay() public pure {
        uint256 feeAt3 = DynamicFeeLib.calculateDynamicFee(3 ether);
        uint256 feeAt10 = DynamicFeeLib.calculateDynamicFee(10 ether);
        uint256 feeAt19 = DynamicFeeLib.calculateDynamicFee(19 ether);

        assertGe(feeAt3, feeAt10, "tier 2: 3 < 10 ETH => higher fee at 3");
        assertGe(feeAt10, feeAt19, "tier 2: 10 < 19 ETH => higher fee at 10");
    }

    /// @dev Tier 3 (20–200 ETH): within-tier decay
    function test_tier3_withinTierDecay() public pure {
        uint256 feeAt50 = DynamicFeeLib.calculateDynamicFee(50 ether);
        uint256 feeAt100 = DynamicFeeLib.calculateDynamicFee(100 ether);
        uint256 feeAt190 = DynamicFeeLib.calculateDynamicFee(190 ether);

        assertGe(feeAt50, feeAt100);
        assertGe(feeAt100, feeAt190);
    }

    /// @dev Tier 4 (200+ ETH): within-tier decay
    function test_tier4_withinTierDecay() public pure {
        uint256 feeAt900 = DynamicFeeLib.calculateDynamicFee(900 ether);
        uint256 feeAt2000 = DynamicFeeLib.calculateDynamicFee(2000 ether);

        assertGe(feeAt900, feeAt2000);
    }

    // ------------------------------------------
    //  Determinism & Consistency
    // ------------------------------------------

    function test_determinism() public pure {
        uint256 volume = 42.5 ether;
        uint256 fee1 = DynamicFeeLib.calculateDynamicFee(volume);
        uint256 fee2 = DynamicFeeLib.calculateDynamicFee(volume);
        assertEq(fee1, fee2);
    }

    function test_harnessMatchesLibrary() public view {
        uint256[] memory volumes = new uint256[](5);
        volumes[0] = 0;
        volumes[1] = 1 ether;
        volumes[2] = 100 ether;
        volumes[3] = 1000 ether;
        volumes[4] = 5000 ether;

        for (uint256 i = 0; i < volumes.length; i++) {
            uint256 libFee = DynamicFeeLib.calculateDynamicFee(volumes[i]);
            uint256 harnessFee = harness.calculateDynamicFee(volumes[i]);
            assertEq(libFee, harnessFee);
        }
    }

    // ------------------------------------------
    //  Floor Behavior
    // ------------------------------------------

    /// @dev DynamicFeeLib and DynamicFeeEth share the same formula; fees must match
    function test_parityWithDynamicFeeEth() public {
        DynamicFeeEthHarness ethHarness = new DynamicFeeEthHarness();
        uint256[] memory volumes = new uint256[](6);
        volumes[0] = 0;
        volumes[1] = 1 ether;
        volumes[2] = 10 ether;
        volumes[3] = 100 ether;
        volumes[4] = 1000 ether;
        volumes[5] = 5000 ether;

        for (uint256 i = 0; i < volumes.length; i++) {
            uint256 libFee = harness.calculateDynamicFee(volumes[i]);
            uint256 ethFee = ethHarness.calculateDynamicFee(volumes[i]);
            assertEq(libFee, ethFee, "DynamicFeeLib and DynamicFeeEth must match");
        }
    }

    function test_approachesFloorAtHighVolume() public pure {
        uint256 fee = DynamicFeeLib.calculateDynamicFee(100_000 ether);
        assertLe(fee, 70, "very high volume should be near 0.6% floor");
        assertGe(fee, FEE_MIN_BPS);
    }
}
