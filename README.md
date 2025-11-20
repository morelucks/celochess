# ♟️ CeloChess – MiniPay-ready on-chain chess

CeloChess is a mobile-first chess experience that uses the Celo blockchain so every move, wager, and reward is transparent and verifiable. The project targets the [Celo MiniPay Hackathon](https://github.com/morelucks/celochess) and focuses on casual competitive play, prediction pools, and educational quests built on a fast, low-fee network.

## Why CeloChess?

- **Mobile-native payments** thanks to MiniPay and Celo’s stable-value assets.
- **Composable wallet UX** using Reown AppKit (WalletConnect v2) for social logins, push notifications, and multi-wallet support.
- **Plug-and-play UI** powered by Composer Kit so we can ship polished wallet, payment, and NFT surfaces without rebuilding primitives.
- **Gaming + Payments**: chess duels, prediction markets, and educational quests that reward consistent play.

## Core Features

| Area | Description |
| --- | --- |
| Wallet | Reown AppKit for MiniPay + other Celo wallets, with social login fallback. |
| UI | Composer Kit components for wallet cards, balances, swaps, and NFT rewards. |
| Gameplay | **On-chain chess matches** with full move validation and state tracking. |
| PvP Mode | Player vs Player matches with ERC-20 token staking and winner-takes-all prize pools. |
| PvC Mode | Player vs Computer matches with on-chain AI opponent (optional staking). |
| Smart Contracts | Solidity contracts deployed on Celo for match management, staking escrow, and move validation. |
| Rewards | cUSD-based rewards, prediction pools, and optional NFT trophies. |
| Docs | Complete setup guide with deployment instructions for Celo Alfajores and Mainnet. |

## Architecture at a Glance

```
client/             # React + Vite frontend
  src/chess/        # Chess UI/logic (to be integrated with on-chain contracts)
  src/components/   # Status bar, landing page, stats, etc.
  src/zustand/      # Local UI/game state
contract/           # Solidity smart contracts (Foundry)
  src/match/        # MatchManager.sol - PvP & PvC match lifecycle
  src/chess/        # BoardLib.sol, ChessAI.sol - chess logic & AI
  test/             # Comprehensive test suite (14 tests)
  script/           # Deployment scripts for Celo networks
```

### Smart Contract Features 
1. **Match Management** – Create, join, and manage chess matches on-chain
2. **PvP Mode** – Player vs Player with ERC-20 token staking and escrow
3. **PvC Mode** – Player vs Computer with on-chain AI opponent
4. **Move Validation** – Turn-based validation using BoardLib
5. **Staking Escrow** – Secure token escrow with winner-takes-all payouts
6. **Chess Logic** – BoardLib for move encoding/decoding and turn management
7. **AI Opponent** – Deterministic on-chain AI for PvC matches


## Getting Started

Prerequisites: Node 18+, pnpm.

```bash
cd client
pnpm install
pnpm dev
```

The chess experience runs locally with mocked wallet hooks. As we wire in Reown AppKit, the provider will live in `client/src/providers/` (TBD) and Composer Kit components will replace the placeholder status bar and landing CTAs.

## Contributing

1. Fork https://github.com/morelucks/celochess.git
2. Create feature branches (`feat/reown-integration`, `feat/composer-kit-ui`, etc.).
3. Open PRs with screenshots or Loom demos when possible.

## License

MIT

---

Built for the Celo MiniPay Hackathon. Let's make chess feel instant, social, and rewarding on Celo. ♟️
