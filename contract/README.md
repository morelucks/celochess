## CeloChess Smart Contracts

This folder houses the on-chain logic for **CeloChess**. Contracts are written in Solidity, tested with Foundry, and target the Celo Alfajores and Mainnet networks.

### Project layout

```
src/
  match/MatchManager.sol   # Main contract - PvP & PvC match lifecycle, staking escrow
  chess/
    BoardLib.sol           # Chess board utilities (move encoding, turn validation)
    ChessAI.sol             # On-chain AI opponent for PvC matches
script/
  DeployMatchManager.s.sol # Deployment script for MatchManager
test/
  MatchManager.t.sol        # Comprehensive test suite (12 tests)
  BoardLib.t.sol            # BoardLib unit tests (2 tests)
```

### Contract Features

- **MatchManager**: Core contract managing chess matches
  - PvP Mode: Player vs Player with ERC-20 token staking
  - PvC Mode: Player vs Computer with on-chain AI
  - Staking Escrow: Secure token escrow with winner-takes-all payouts
  - Move Validation: Turn-based validation with BoardLib integration
  - Match Lifecycle: Create, join, submit moves, finish matches

- **BoardLib**: Chess board utilities
  - Move encoding/decoding (bytes4 format)
  - Square validation (0-63 range)
  - Turn detection (white/black based on move count)

- **ChessAI**: On-chain AI opponent
  - Deterministic move generation
  - State-based strategy
  - Automatic move execution in PvC matches

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

### Testing

Run the full test suite:

```bash
forge test
```

Run with gas reporting:

```bash
forge test --gas-report
```

Run specific test:

```bash
forge test --match-test testCreatePvCMatchAutoStarts
```

### Deploying to Celo Alfajores (Testnet)

1. Set up environment variables:

```bash
export PRIVATE_KEY=0x...  # Your deployer private key
export CELO_ALFAJORES_RPC=https://alfajores-forno.celo-testnet.org
```

2. Deploy MatchManager:

```bash
forge script script/DeployMatchManager.s.sol:DeployMatchManager \
  --rpc-url $CELO_ALFAJORES_RPC \
  --broadcast \
  --verify --verifier sourcify \
  --etherscan-api-key $CELO_API_KEY  # Optional: for verification
```

3. Save the deployed contract address for frontend integration.

### Deploying to Celo Mainnet

⚠️ **Warning**: Only deploy to mainnet after thorough testing on Alfajores.

```bash
export PRIVATE_KEY=0x...
export CELO_MAINNET_RPC=https://forno.celo.org

forge script script/DeployMatchManager.s.sol:DeployMatchManager \
  --rpc-url $CELO_MAINNET_RPC \
  --broadcast \
  --verify --verifier sourcify \
  --etherscan-api-key $CELO_API_KEY
```

### Contract Addresses

After deployment, update these addresses in your frontend configuration:

- **Alfajores**: `0x...` (update after deployment)
- **Mainnet**: `0x...` (update after deployment)

### Contract Interaction Examples

#### Create a PvP Match

```solidity
// Player stakes 100 tokens (must approve first)
IERC20(token).approve(matchManager, 100 * 10**18);
matchManager.createMatch(
    GameMode.PvP,
    PlayerColor.White,
    token,
    100 * 10**18,
    initialBoardHash
);
```

#### Create a PvC Match

```solidity
// PvC matches can have optional staking (0 for free play)
matchManager.createMatch(
    GameMode.PvC,
    PlayerColor.White,
    address(0),  // No token
    0,           // No stake
    initialBoardHash
);
```

#### Submit a Move

```solidity
bytes4 move = BoardLib.encodeMove(fromSquare, toSquare, extraData);
bytes32 newStateHash = keccak256(abi.encodePacked(oldStateHash, move));
matchManager.submitMove(matchId, newStateHash, abi.encodePacked(move));
```

### Security Considerations

- ✅ All moves are validated on-chain
- ✅ Staking escrow prevents fund loss
- ✅ Turn validation prevents invalid moves
- ✅ PvC matches only allow human players to win
- ⚠️ AI moves are deterministic (consider adding randomness for production)
- ⚠️ Board state validation is hash-based (consider full FEN validation)

### Next Steps

1. ✅ MatchManager with staking + move validation
2. ✅ PvC mode with on-chain AI
3. 🔄 Frontend integration with deployed contract
4. 🔄 Enhanced AI strategy (currently basic deterministic moves)
5. 🔄 Full FEN validation for board states
6. 🔄 CI/CD pipeline (Forge + Slither) before mainnet
