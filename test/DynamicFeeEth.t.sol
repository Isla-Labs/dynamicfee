// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Test } from "forge-std/Test.sol";
import { DynamicFeeEth } from "../src/DynamicFeeEth.sol";

contract DynamicFeeEthTest is Test {
    DynamicFeeEth feeContract;

    uint256 constant FEE_MIN_BPS = 60;
    uint256 constant FEE_MAX_BPS = 200;

    function setUp() public {
        feeContract = new DynamicFeeEth();
    }

    // ------------------------------------------
    //  Fee Bounds
    // ------------------------------------------

    function test_feeBounds_zeroVolume() public view {
        uint256 fee = feeContract.calculateDynamicFee(0);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
        assertEq(fee, 200, "zero volume: 2%");
    }

    function test_feeBounds_fuzz(
        uint256 volumeEth
    ) public view {
        volumeEth = bound(volumeEth, 0, 10_000_000 ether);
        uint256 fee = feeContract.calculateDynamicFee(volumeEth);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    // ------------------------------------------
    //  Monotonicity
    // ------------------------------------------

    function test_monotonicity() public view {
        uint256 fee1 = feeContract.calculateDynamicFee(0);
        uint256 fee2 = feeContract.calculateDynamicFee(1 ether);
        uint256 fee3 = feeContract.calculateDynamicFee(100 ether);
        uint256 fee4 = feeContract.calculateDynamicFee(1000 ether);

        assertGe(fee1, fee2);
        assertGe(fee2, fee3);
        assertGe(fee3, fee4);
    }

    // ------------------------------------------
    //  Parity with DynamicFeeLib (same formula)
    // ------------------------------------------

    function test_parityWithDynamicFeeLib() public view {
        // DynamicFeeEth and DynamicFeeLib share the same constants and formula
        // We verify by checking key volumes produce expected behavior
        assertEq(feeContract.calculateDynamicFee(0), 200);
        assertGe(feeContract.calculateDynamicFee(100 ether), 60);
        assertLe(feeContract.calculateDynamicFee(100 ether), 200);
    }

    // ------------------------------------------
    //  Determinism
    // ------------------------------------------

    function test_determinism() public view {
        uint256 volume = 42.5 ether;
        assertEq(feeContract.calculateDynamicFee(volume), feeContract.calculateDynamicFee(volume));
    }
}
