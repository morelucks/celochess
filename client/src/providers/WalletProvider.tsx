import { createAppKit, AppKitProvider } from '@reown/appkit/react'
import { WagmiProvider } from 'wagmi'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { createConfig, http } from 'wagmi'
import { celo, celoAlfajores, base } from 'viem/chains'

// Configure Celo chains
const chains = [celoAlfajores, celo, base] as const

// Create wagmi config
const wagmiConfig = createConfig({
  chains,
  transports: {
    [celoAlfajores.id]: http(),
    [celo.id]: http(),
    [base.id]: http(),
  },
})

// Create React Query client
const queryClient = new QueryClient()

// AppKit metadata
const metadata = {
  name: 'CeloChess',
  description: 'On-chain chess on Celo',
  url: 'https://celochess.vercel.app',
  icons: ['https://celochess.vercel.app/logo.png'],
}

// Create AppKit
export const appKit = createAppKit({
  wagmi: wagmiConfig,
  projectId: import.meta.env.VITE_WALLET_CONNECT_PROJECT_ID || 'YOUR_PROJECT_ID',
  metadata,
  features: {
    analytics: true,
    email: true,
    socials: ['google', 'x', 'github', 'apple'],
  },
  themeMode: 'dark',
  themeVariables: {
    '--w3m-accent': '#10b981', // emerald-500
  },
  networks: chains,
})

export function WalletProvider({ children }: { children: React.ReactNode }) {
  return (
    <WagmiProvider config={wagmiConfig}>
      <AppKitProvider appKit={appKit}>
        <QueryClientProvider client={queryClient}>
          {children}
        </QueryClientProvider>
      </AppKitProvider>
    </WagmiProvider>
  )
}

