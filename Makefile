include .env
export

LIB_PATH := src/libraries/ExponentialMathLib.sol:ExponentialMathLib

# Deployment history
generate-history:
	@bun run ./deployments/cli.ts --output history

# Base Sepolia
deploy-base-sepolia-exp:
	@forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia-lib:
	@EXP_LIB=$${EXP_LIB_BASE_SEPOLIA:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployBaseSepolia.s.sol/84532/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-base-sepolia-exp) or set EXP_LIB_BASE_SEPOLIA"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia-eth:
	@EXP_LIB=$${EXP_LIB_BASE_SEPOLIA:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployBaseSepolia.s.sol/84532/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-base-sepolia-exp) or set EXP_LIB_BASE_SEPOLIA"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia-usd:
	@EXP_LIB=$${EXP_LIB_BASE_SEPOLIA:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployBaseSepolia.s.sol/84532/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-base-sepolia-exp) or set EXP_LIB_BASE_SEPOLIA"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia: deploy-base-sepolia-exp deploy-base-sepolia-lib deploy-base-sepolia-eth deploy-base-sepolia-usd

# Base mainnet
deploy-base-exp:
	@forge script script/DeployBase/DeployBase.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-lib:
	@EXP_LIB=$${EXP_LIB_BASE:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployBase.s.sol/8453/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-base-exp) or set EXP_LIB_BASE"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployBase/DeployBase.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-eth:
	@EXP_LIB=$${EXP_LIB_BASE:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployBase.s.sol/8453/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-base-exp) or set EXP_LIB_BASE"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployBase/DeployBase.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-usd:
	@EXP_LIB=$${EXP_LIB_BASE:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployBase.s.sol/8453/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-base-exp) or set EXP_LIB_BASE"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployBase/DeployBase.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(BASESCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base: deploy-base-exp deploy-base-lib deploy-base-eth deploy-base-usd

# Ethereum Sepolia
deploy-ethereum-sepolia-exp:
	@forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_MAINNET)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia-lib:
	@EXP_LIB=$${EXP_LIB_ETHEREUM_SEPOLIA:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployEthereumSepolia.s.sol/11155111/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-ethereum-sepolia-exp) or set EXP_LIB_ETHEREUM_SEPOLIA"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_MAINNET)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia-eth:
	@EXP_LIB=$${EXP_LIB_ETHEREUM_SEPOLIA:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployEthereumSepolia.s.sol/11155111/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-ethereum-sepolia-exp) or set EXP_LIB_ETHEREUM_SEPOLIA"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_MAINNET)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia-usd:
	@EXP_LIB=$${EXP_LIB_ETHEREUM_SEPOLIA:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployEthereumSepolia.s.sol/11155111/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-ethereum-sepolia-exp) or set EXP_LIB_ETHEREUM_SEPOLIA"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_MAINNET)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia: deploy-ethereum-sepolia-exp deploy-ethereum-sepolia-lib deploy-ethereum-sepolia-eth deploy-ethereum-sepolia-usd

# Ethereum mainnet
deploy-ethereum-exp:
	@forge script script/DeployEthereum/DeployEthereum.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-lib:
	@EXP_LIB=$${EXP_LIB_ETHEREUM:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployEthereum.s.sol/1/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-ethereum-exp) or set EXP_LIB_ETHEREUM"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployEthereum/DeployEthereum.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-eth:
	@EXP_LIB=$${EXP_LIB_ETHEREUM:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployEthereum.s.sol/1/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-ethereum-exp) or set EXP_LIB_ETHEREUM"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployEthereum/DeployEthereum.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-usd:
	@EXP_LIB=$${EXP_LIB_ETHEREUM:-$$(jq -r '.returns."0".value // .transactions[0].contractAddress' broadcast/DeployEthereum.s.sol/1/run-latest.json 2>/dev/null)}; \
	if [ -z "$$EXP_LIB" ] || [ "$$EXP_LIB" = "null" ]; then echo "Error: Deploy ExponentialMathLib first (make deploy-ethereum-exp) or set EXP_LIB_ETHEREUM"; exit 1; fi; \
	echo "ExponentialMathLib: $$EXP_LIB"; \
	forge script script/DeployEthereum/DeployEthereum.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--libraries "$(LIB_PATH):$$EXP_LIB" \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum: deploy-ethereum-exp deploy-ethereum-lib deploy-ethereum-eth deploy-ethereum-usd

# Build & test
install:
	forge install

build:
	forge build

test:
	forge test --show-progress

coverage:
	forge coverage --ir-minimum --report lcov

fmt:
	forge fmt
