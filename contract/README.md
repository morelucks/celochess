## CeloChess Smart Contracts

This folder houses the on-chain logic for **CeloChess**. Contracts are written in Solidity, tested with Foundry, and target the Celo Alfajores and Mainnet networks.

### Project layout

```
src/
  match/MatchManager.sol   # placeholder contract – will track matches & wagers
script/DeployMatchManager.s.sol  # Foundry deploy script scaffold
test/MatchManager.t.sol    # sanity test to keep the pipeline green
```

### Prerequisites

- Foundry (`curl -L https://foundry.paradigm.xyz | bash`)
- Node 18+ if you plan to run scripts that consume shared env files
- A Celo RPC URL (e.g. from https://forno.celo.org or Infura/QuickNode)

### Common commands

```bash
# install forge libraries
forge install

# compile contracts
forge build

# run tests
forge test

# format solidity
forge fmt
```

### Network configuration

`foundry.toml` already defines a `celo` profile (Paris EVM + tuned optimizer).  
Run commands against it with `--profile celo` if needed.

### Deploying to Alfajores (example)

```bash
export PRIVATE_KEY=0x...
export CELO_ALFAJORES_RPC=https://alfajores-forno.celo-testnet.org

forge script script/DeployMatchManager.s.sol:DeployMatchManager \\
  --rpc-url $CELO_ALFAJORES_RPC \\
  --broadcast \\
  --verify --verifier sourcify
```

### Next steps

1. Flesh out `MatchManager` with staking + move validation.
2. Add dedicated contracts for PvC and prediction pools.
3. Wire CI (Forge + Slither) before mainnet deployment.
