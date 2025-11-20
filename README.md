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
| Gameplay | Local chess engine today; on-chain move verification and settlement on Celo later. |
| Rewards | cUSD-based rewards, prediction pools, and optional NFT trophies. |
| Docs | Straightforward setup so hackathon judges can clone, run, and extend. |

## Architecture at a Glance

```
client/             # React + Vite frontend
  src/chess/        # Existing chess UI/logic (local engine for now)
  src/components/   # Status bar, landing page, stats, etc.
  src/zustand/      # Local UI/game state
contract/           # Placeholder for Solidity contracts (Celo-compatible)
```

### Immediate Roadmap

1. **Wallet Layer** – integrate Reown AppKit with Celo chain config.
2. **UI Layer** – replace custom wallet banners with Composer Kit `Wallet`, `Payment`, and `Identity` blocks.
3. **Smart Contracts** – migrate from Cairo/Dojo to Solidity (Foundry + Hardhat). Deploy lightweight match + rewards contracts on Celo Alfajores/mainnet.
4. **MiniPay polish** – optimize for mobile webview (lightweight assets, OTP logins, shareable links).

## Tech Stack

- **Framework**: React 18, Vite, TypeScript, Tailwind, Zustand.
- **Wallet & Identity**: Reown AppKit (WalletConnect v2).
- **UI Library**: Composer Kit UI (`@composer-kit/ui`).
- **Blockchain**: Celo (start with Alfajores testnet, target MiniPay-compatible mainnet deployment).
- **Contracts**: Solidity (Foundry + Hardhat). The old Cairo/Dojo stack has been removed.

## Getting Started

Prerequisites: Node 18+, pnpm.

```bash
cd client
pnpm install
pnpm dev
```

The chess experience runs locally with mocked wallet hooks. As we wire in Reown AppKit, the provider will live in `client/src/providers/` (TBD) and Composer Kit components will replace the placeholder status bar and landing CTAs.

## Deployment Plan

1. Hook Reown AppKit into a new `WalletProvider`.
2. Wrap the app with `ComposerKitProvider`.
3. Implement payment/prediction flows against Celo Alfajores smart contracts.
4. Provide a demo video + docs covering MiniPay onboarding, gameplay, and payouts.

## Contributing

1. Fork https://github.com/morelucks/celochess.git
2. Create feature branches (`feat/reown-integration`, `feat/composer-kit-ui`, etc.).
3. Open PRs with screenshots or Loom demos when possible.

## License

MIT

---

Built for the Celo MiniPay Hackathon. Let's make chess feel instant, social, and rewarding on Celo. ♟️
