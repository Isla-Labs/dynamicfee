include .env
export

# Deployment history
generate-history:
	@bun run ./deployments/cli.ts --output history

# Ethereum mainnet
deploy-ethereum-exp:
	@forge script script/DeployEthereum/DeployEthereum.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-lib:
	@forge script script/DeployEthereum/DeployEthereum.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-eth:
	@forge script script/DeployEthereum/DeployEthereum.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-usd:
	@forge script script/DeployEthereum/DeployEthereum.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum:
	@forge script script/DeployEthereum/DeployEthereum.s.sol:DeployAll \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

# Ethereum Sepolia
deploy-ethereum-sepolia-exp:
	@forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia-lib:
	@forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia-eth:
	@forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia-usd:
	@forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-ethereum-sepolia:
	@forge script script/DeployEthereum/DeployEthereumSepolia.s.sol:DeployAll \
		--private-key $(PRIVATE_KEY) --rpc-url $(ETHEREUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ETHEREUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

# Base mainnet
deploy-base-exp:
	@forge script script/DeployBase/DeployBase.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-lib:
	@forge script script/DeployBase/DeployBase.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-eth:
	@forge script script/DeployBase/DeployBase.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-usd:
	@forge script script/DeployBase/DeployBase.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base:
	@forge script script/DeployBase/DeployBase.s.sol:DeployAll \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

# Base Sepolia
deploy-base-sepolia-exp:
	@forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia-lib:
	@forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia-eth:
	@forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia-usd:
	@forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-base-sepolia:
	@forge script script/DeployBase/DeployBaseSepolia.s.sol:DeployAll \
		--private-key $(PRIVATE_KEY) --rpc-url $(BASE_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_BASE_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

# Arbitrum
deploy-arbitrum-exp:
	@forge script script/DeployArbitrum/DeployArbitrum.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-lib:
	@forge script script/DeployArbitrum/DeployArbitrum.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-eth:
	@forge script script/DeployArbitrum/DeployArbitrum.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-usd:
	@forge script script/DeployArbitrum/DeployArbitrum.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum:
	@forge script script/DeployArbitrum/DeployArbitrum.s.sol:DeployAll \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_MAINNET_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

# Arbitrum Sepolia
deploy-arbitrum-sepolia-exp:
	@forge script script/DeployArbitrum/DeployArbitrumSepolia.s.sol:DeployExponentialMathLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-sepolia-lib:
	@forge script script/DeployArbitrum/DeployArbitrumSepolia.s.sol:DeployDynamicFeeLib \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-sepolia-eth:
	@forge script script/DeployArbitrum/DeployArbitrumSepolia.s.sol:DeployDynamicFeeEth \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-sepolia-usd:
	@forge script script/DeployArbitrum/DeployArbitrumSepolia.s.sol:DeployDynamicFeeUsd \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

deploy-arbitrum-sepolia:
	@forge script script/DeployArbitrum/DeployArbitrumSepolia.s.sol:DeployAll \
		--private-key $(PRIVATE_KEY) --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--verify --verifier-url "$(VERIFIER_URL)$(CHAIN_ID_ARBITRUM_SEPOLIA)" --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --slow
	$(MAKE) generate-history

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
