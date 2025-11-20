import { useAccount, useConnect, useDisconnect } from 'wagmi'

export function useWallet() {
  const { address, isConnected, chain } = useAccount()
  const { connect, connectors, isPending: isConnecting } = useConnect()
  const { disconnect } = useDisconnect()

  const handleConnect = async () => {
    if (connectors[0]) {
      connect({ connector: connectors[0] })
    }
  }

  const handleDisconnect = () => {
    disconnect()
  }

  return {
    address,
    isConnected,
    isConnecting,
    chain,
    connect: handleConnect,
    disconnect: handleDisconnect,
    status: isConnected ? 'connected' : 'disconnected',
  }
}

