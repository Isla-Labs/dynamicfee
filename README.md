[![License:MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/license/mit) [![solidity](https://img.shields.io/badge/solidity-%5E0.8.34-black)](https://docs.soliditylang.org/en/v0.8.34/) [![Foundry](https://img.shields.io/badge/Built%20with-Foundry-000000.svg)](https://getfoundry.sh/)

# DynamicFee

A gas-efficient, zero-dependency library for dynamic fee calculation with exponential decay. Fee rates decline as transaction volume increases, within configurable tiers.

## Formula

```
ϕ(v) = f_min + (ϕ_start - f_min) ⋅ e^(−α ⋅ (v−v_start) / κ)
```

| Symbol | Description |
|--------|--------------|
| ϕ | Calculated fee rate (output, in basis points) |
| v | Transaction volume (input) |
| f_min | Minimum fee floor (e.g. 1% = 100 bps) |
| v_start | Starting volume threshold for the current tier |
| ϕ_start | Initial fee value at tier start (bps) |
| α | Decay factor for the current tier |
| κ | Scale parameter (1000) |

The fee rate decays exponentially as transaction volume increases. Four predefined tiers each have their own `v_start`, `ϕ_start`, and `α`. The only variable input is transaction volume for fetching the variable fee rate output.

## Variants

### DynamicFeeEth

ETH-denominated tiers. No oracle required.

- **Tiers:** Fully configurable; placeholder uses 0, 2 ETH, 20 ETH, 200 ETH
- **Fee bounds:** Fully configurable; placeholder uses 2.00% max (low volume) → 0.60% min (high volume)
- **Alpha values:** Fully configurable; placeholder uses variable decay factors for each volume tier (300, 50, 100, 300)

Use when you want simple, trustless fee logic without external price feeds.

### DynamicFeeUsd

USD-denominated tiers via Chainlink ETH/USD price feed. Stable fee tiers regardless of ETH price.

- **Tiers:** Fully configurable; placeholder uses 0 USD, 500 USD, 5_000 USD, 50_000 USD
- **Fee bounds:** Fully configurable; placeholder uses 5.00% max → 1.00% min
- **Alpha values:** Fully configurable; placeholder uses variable decay factors for each volume tier (100, 120, 50, 100)
- **Fallback:** Uses `FALLBACK_ETH_PRICE` when feed is stale or unavailable (e.g. testnets)

Use when you want volume-based tiers in USD terms.

## Features

- **Zero dependencies** — Custom `ExponentialMathLib` for e^(-x/1000) (Taylor series + range reduction); no prb-math or other libs
- **Gas-efficient** — Pure library (`DynamicFeeLib`) for stateless calculation; abstract contracts for integration
- **Configurable** — Tier thresholds, decay factors, and fee bounds are constants you can tune
- **Oracle-optional** — `DynamicFeeEth` needs no oracle; `DynamicFeeUsd` uses Chainlink with staleness fallback

## Contracts

| Contract | Type | Description |
|----------|------|-------------|
| `DynamicFeeLib` | Library | Pure fee calculation; volume in ETH wei |
| `DynamicFeeEth` | Abstract | ETH-denominated; inherit and implement |
| `DynamicFeeUsd` | Abstract | USD-denominated; Chainlink + fallback |
| `ExponentialMathLib` | Library | e^(-x/1000) with 18-decimal precision |

## Deployment

Deploy ExponentialMathLib first, then deploy DynamicFeeLib, DynamicFeeEth, and/or DynamicFeeUsd. You can deploy all at once or choose specific contracts.

```bash
# Copy .env.example to .env and set PRIVATE_KEY, RPC URLs, and API keys
cp .env.example .env

# Deploy all (exp + lib + eth + usd)
make deploy-base-sepolia      # Base Sepolia
make deploy-base              # Base mainnet
make deploy-ethereum-sepolia  # Ethereum Sepolia
make deploy-ethereum          # Ethereum mainnet

# Deploy individually (requires ExponentialMathLib first)
make deploy-base-sepolia-exp   # ExponentialMathLib only
make deploy-base-sepolia-lib   # DynamicFeeLib
make deploy-base-sepolia-eth   # DynamicFeeEth
make deploy-base-sepolia-usd   # DynamicFeeUsd
```

For lib/eth/usd targets, `EXP_LIB` is read from the broadcast file after a prior `-exp` deploy, or you can set `EXP_LIB` in `.env` if you deployed ExponentialMathLib elsewhere. Chainlink ETH/USD addresses are set per network in the scripts.

## Getting Started

Install Foundry: `curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup`

```bash
forge build
forge test
forge fmt
```

## Blueprint

```txt
lib
└─ forge-std — https://github.com/foundry-rs/forge-std
src
├─ DynamicFeeLib.sol    — Pure library (ETH tiers)
├─ DynamicFeeEth.sol    — Abstract contract (ETH tiers)
├─ DynamicFeeUsd.sol    — Abstract contract (USD tiers, Chainlink)
└─ libraries
   └─ ExponentialMathLib.sol
test
├─ ExponentialMathLib.t.sol
├─ DynamicFeeLib.t.sol
├─ DynamicFeeEth.t.sol
└─ DynamicFeeUsd.t.sol
```

## Security

Audited by [Zellic V12](https://zellic.ai/) AI scan — [report](./audit/zellic-V12-AI/). No valid findings.

## Disclaimer

*These smart contracts and testing suite are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of anything provided herein or through related user interfaces. This repository and related code have not been audited and as such there can be no assurance anything will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk.*

## License

See [LICENSE](./LICENSE) for more details.
