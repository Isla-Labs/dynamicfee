// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Test} from "forge-std/Test.sol";
import {DynamicFeeUsd} from "../src/DynamicFeeUsd.sol";

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

/// @notice Mock Chainlink ETH/USD price feed for testing
contract MockChainlinkEthUsd is AggregatorV3Interface {
    int256 public price; // 8 decimals (e.g. 3000e8 = $3000)
    uint256 public updatedAt;
    uint8 public override decimals = 8;

    constructor(int256 _price) {
        price = _price;
        updatedAt = block.timestamp;
    }

    function setPrice(int256 _price) external {
        price = _price;
        updatedAt = block.timestamp;
    }

    function setUpdatedAt(uint256 _updatedAt) external {
        updatedAt = _updatedAt;
    }

    function latestRoundData()
        external
        view
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt_, uint80 answeredInRound)
    {
        return (1, price, block.timestamp - 1 hours, updatedAt, 1);
    }
}

contract DynamicFeeUsdConcrete is DynamicFeeUsd {
    constructor(address _chainlinkEthUsd) DynamicFeeUsd(_chainlinkEthUsd) {}
}

contract DynamicFeeUsdTest is Test {
    DynamicFeeUsdConcrete feeContract;
    MockChainlinkEthUsd mockFeed;

    uint256 constant FEE_MIN_BPS = 100;
    uint256 constant FEE_MAX_BPS = 500;
    /// @dev Fallback price: $3000 with 6 decimals
    uint256 constant FALLBACK_PRICE_6DEC = 3_000_000_000;

    function setUp() public {
        // Use address(0) for fallback-only tests; deploy mock for oracle tests
        feeContract = new DynamicFeeUsdConcrete(address(0));
    }

    // ------------------------------------------
    //  Fallback Mode (address(0) feed)
    // ------------------------------------------

    function test_fallbackMode_zeroVolume() public view {
        uint256 fee = feeContract.calculateDynamicFee(0);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
        assertEq(fee, 500, "zero volume: 5%");
    }

    function test_fallbackMode_feeBounds() public view {
        uint256 fee = feeContract.calculateDynamicFee(1 ether);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    function test_fallbackMode_monotonicity() public view {
        uint256 fee1 = feeContract.calculateDynamicFee(0);
        uint256 fee2 = feeContract.calculateDynamicFee(1 ether);
        uint256 fee3 = feeContract.calculateDynamicFee(10 ether);
        uint256 fee4 = feeContract.calculateDynamicFee(100 ether);

        assertGe(fee1, fee2);
        assertGe(fee2, fee3);
        assertGe(fee3, fee4);
    }

    function test_fallbackMode_fuzz(uint256 volumeEth) public view {
        volumeEth = bound(volumeEth, 0, 10_000 ether);
        uint256 fee = feeContract.calculateDynamicFee(volumeEth);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    // ------------------------------------------
    //  Oracle Mode (mock Chainlink)
    // ------------------------------------------

    function test_oracleMode_validPrice() public {
        // $3000/ETH, 8 decimals
        mockFeed = new MockChainlinkEthUsd(3000e8);
        feeContract = new DynamicFeeUsdConcrete(address(mockFeed));

        uint256 fee = feeContract.calculateDynamicFee(1 ether);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    function test_oracleMode_differentPrices() public {
        mockFeed = new MockChainlinkEthUsd(2000e8);
        feeContract = new DynamicFeeUsdConcrete(address(mockFeed));
        uint256 feeAt2k = feeContract.calculateDynamicFee(1 ether);

        mockFeed = new MockChainlinkEthUsd(4000e8);
        feeContract = new DynamicFeeUsdConcrete(address(mockFeed));
        uint256 feeAt4k = feeContract.calculateDynamicFee(1 ether);

        // Same ETH volume, different USD value: 1 ETH at $4k = $4k volume, at $2k = $2k volume
        // Higher USD volume => lower fee
        assertGe(feeAt2k, feeAt4k);
    }

    function test_oracleMode_staleDataUsesFallback() public {
        mockFeed = new MockChainlinkEthUsd(3000e8);
        feeContract = new DynamicFeeUsdConcrete(address(mockFeed));

        // Make data stale (> 1 day)
        vm.warp(block.timestamp + 2 days);
        mockFeed.setUpdatedAt(block.timestamp - 2 days);

        // Should fall back to FALLBACK_ETH_PRICE
        uint256 fee = feeContract.calculateDynamicFee(1 ether);
        assertGe(fee, FEE_MIN_BPS);
        assertLe(fee, FEE_MAX_BPS);
    }

    // ------------------------------------------
    //  Determinism
    // ------------------------------------------

    function test_determinism() public view {
        uint256 volume = 5 ether;
        assertEq(feeContract.calculateDynamicFee(volume), feeContract.calculateDynamicFee(volume));
    }
}
