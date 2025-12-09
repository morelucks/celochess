import { useWriteContract, useWaitForTransactionReceipt, useReadContract } from 'wagmi'
import { parseAbi } from 'viem'
import { getMatchManagerAddress } from '../config/contracts'

// MatchManager ABI (minimal for key functions)
const MATCH_MANAGER_ABI = parseAbi([
  'function createMatch(uint8 mode, uint8 creatorColor, address stakeToken, uint256 stakeAmount, bytes32 initialStateHash) external returns (uint256)',
  'function joinMatch(uint256 matchId) external',
  'function submitMove(uint256 matchId, bytes32 newStateHash, bytes calldata moveData) external',
  'function finishMatch(uint256 matchId, address winner) external',
  'function getMatch(uint256 matchId) external view returns (tuple(uint256 id, uint8 mode, uint8 status, tuple(address token, uint256 amount) stake, tuple(address account, uint8 color, uint256 joinedAt, bool escrowed) white, tuple(address account, uint8 color, uint256 joinedAt, bool escrowed) black, tuple(bytes32 fenHash, uint8 moveCount) board, address winner, uint256 createdAt, uint256 updatedAt, uint256 pot))',
])

export function useMatchManager(chainId?: number) {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const createPvCMatch = () => {
    const initialStateHash = '0x0000000000000000000000000000000000000000000000000000000000000000'
    return writeContract({
      address: getMatchManagerAddress(chainId),
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
      address: getMatchManagerAddress(chainId),
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

