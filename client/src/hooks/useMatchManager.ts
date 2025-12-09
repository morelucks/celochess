import { useWriteContract, useWaitForTransactionReceipt, useReadContract } from 'wagmi'
import { parseAbi } from 'viem'

// MatchManager ABI (minimal for key functions)
const MATCH_MANAGER_ABI = parseAbi([
  'function createMatch(uint8 mode, uint8 creatorColor, address stakeToken, uint256 stakeAmount, bytes32 initialStateHash) external returns (uint256)',
  'function joinMatch(uint256 matchId) external',
  'function submitMove(uint256 matchId, bytes32 newStateHash, bytes calldata moveData) external',
  'function finishMatch(uint256 matchId, address winner) external',
  'function getMatch(uint256 matchId) external view returns (tuple(uint256 id, uint8 mode, uint8 status, tuple(address token, uint256 amount) stake, tuple(address account, uint8 color, uint256 joinedAt, bool escrowed) white, tuple(address account, uint8 color, uint256 joinedAt, bool escrowed) black, tuple(bytes32 fenHash, uint8 moveCount) board, address winner, uint256 createdAt, uint256 updatedAt, uint256 pot))',
])

// Contract addresses per network
const CONTRACT_ADDRESSES = {
  base: '0x3D15251E40A631793637B2DFD6433EaDEc821853',
  celo: '0x8D092fd130323601de13AFF0D4BA8900c6ca9C9f',
  celoSepolia: '0x3D15251E40A631793637B2DFD6433EaDEc821853',
} as const

export function useMatchManager(chainId?: number) {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const getContractAddress = () => {
    if (chainId === 8453) return CONTRACT_ADDRESSES.base
    if (chainId === 42220) return CONTRACT_ADDRESSES.celo
    if (chainId === 44787) return CONTRACT_ADDRESSES.celoSepolia
    return CONTRACT_ADDRESSES.base // default
  }

  const createPvCMatch = () => {
    const initialStateHash = '0x0000000000000000000000000000000000000000000000000000000000000000'
    return writeContract({
      address: getContractAddress() as `0x${string}`,
      abi: MATCH_MANAGER_ABI,
      functionName: 'createMatch',
      args: [1, 0, '0x0000000000000000000000000000000000000000', 0n, initialStateHash], // PvC mode=1, White=0, no stake
    })
  }

  const submitMove = (matchId: bigint, fromSquare: number, toSquare: number) => {
    // Simple move encoding: first 2 bytes for squares, last 2 bytes for extra data
    const moveData = `0x${fromSquare.toString(16).padStart(2, '0')}${toSquare.toString(16).padStart(2, '0')}0000`
    const newStateHash = '0x' + '0'.repeat(64) // Simplified - should compute from board state
    return writeContract({
      address: getContractAddress() as `0x${string}`,
      abi: MATCH_MANAGER_ABI,
      functionName: 'submitMove',
      args: [matchId, newStateHash as `0x${string}`, moveData as `0x${string}`],
    })
  }

  return {
    createPvCMatch,
    submitMove,
    hash,
    isPending,
    isConfirming,
    isSuccess,
    error,
  }
}

