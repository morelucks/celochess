import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Play, Move, Loader2, ExternalLink } from "lucide-react";
import { useAccount } from 'wagmi';
import { useMatchManager } from "../hooks/useMatchManager";
import { useState } from "react";

export function GameActions() {
  const { address, chainId, isConnected } = useAccount();
  const { createPvCMatch, submitMove, hash, isPending, isConfirming, isSuccess, error } = useMatchManager(chainId);
  const [currentMatchId, setCurrentMatchId] = useState<bigint | null>(null);

  const handleCreateMatch = async () => {
    try {
      await createPvCMatch();
    } catch (err) {
      console.error('Failed to create match:', err);
    }
  };

  const handleSubmitMove = () => {
    if (!currentMatchId) return;
    submitMove(currentMatchId, 12, 28); // Example: e2 to e4
  };

  const getExplorerUrl = (txHash: string) => {
    if (chainId === 8453) return `https://basescan.org/tx/${txHash}`;
    if (chainId === 42220) return `https://celoscan.io/tx/${txHash}`;
    if (chainId === 44787) return `https://sepolia.celoscan.io/tx/${txHash}`;
    return `https://basescan.org/tx/${txHash}`;
  };

  const isLoading = isPending || isConfirming;
  const txStatus = isSuccess ? "SUCCESS" : isLoading ? "PENDING" : null;

  const actions = [
    {
      icon: Play,
      label: "Create PvC Match",
      description: "Start a new game vs AI",
      onClick: handleCreateMatch,
      color: "from-blue-500 to-blue-600",
      canExecute: isConnected && !isLoading,
    },
    {
      icon: Move,
      label: "Submit Move",
      description: "Make a chess move",
      onClick: handleSubmitMove,
      color: "from-green-500 to-green-600",
      canExecute: isConnected && currentMatchId !== null && !isLoading,
      disabledReason: !currentMatchId ? "Create a match first" : undefined,
    },
  ];

  const formatAddress = (addr: string) => {
    if (!addr) return "";
    return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
  };

  return (
    <Card className="bg-white/5 backdrop-blur-xl border-white/10">
      <CardHeader>
        <CardTitle className="text-white text-xl font-bold">
          Game Actions
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        {!isConnected && (
          <div className="bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-3 mb-4">
            <div className="text-yellow-400 text-sm text-center">
              🔗 Connect your wallet to start playing chess
            </div>
          </div>
        )}

        {actions.map((action) => {
          const Icon = action.icon;
          const hasError = Boolean(error);

          return (
            <div key={action.label} className="space-y-2">
              <Button
                onClick={action.onClick}
                disabled={!action.canExecute || isLoading}
                className={`w-full h-14 bg-gradient-to-r ${action.color} hover:scale-105 transition-all duration-300 shadow-lg disabled:opacity-50 disabled:cursor-not-allowed`}
              >
                {isLoading ? (
                  <Loader2 className="w-5 h-5 mr-3 animate-spin" />
                ) : (
                  <Icon className="w-5 h-5 mr-3" />
                )}
                <div className="flex flex-col items-start flex-1">
                  <span className="font-semibold">{action.label}</span>
                  <span className="text-xs opacity-80">
                    {action.description}
                  </span>
                </div>
                {action.disabledReason && (
                  <span className="text-xs opacity-60">
                    {action.disabledReason}
                  </span>
                )}
              </Button>

              {/* Transaction state */}
              {(txStatus || hasError) && (
                <div
                  className={`p-3 rounded-lg border text-sm ${hasError
                      ? "bg-red-500/10 border-red-500/30 text-red-400"
                      : txStatus === "SUCCESS"
                        ? "bg-green-500/10 border-green-500/30 text-green-400"
                        : "bg-yellow-500/10 border-yellow-500/30 text-yellow-400"
                    }`}
                >
                  {hasError ? (
                    `❌ Error: ${error?.message || 'Transaction failed'}`
                  ) : txStatus === "SUCCESS" ? (
                    <div className="space-y-2">
                      <div>✅ {action.label} completed successfully!</div>
                      {hash && (
                        <div className="flex items-center gap-2 text-xs">
                          <span className="font-mono bg-black/20 px-2 py-1 rounded">
                            {formatAddress(hash)}
                          </span>
                          <a
                            href={getExplorerUrl(hash)}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="flex items-center gap-1 hover:underline"
                          >
                            <ExternalLink className="w-3 h-3" />
                            View on Explorer
                          </a>
                        </div>
                      )}
                    </div>
                  ) : (
                    <div className="space-y-2">
                      <div className="flex items-center gap-2">
                        <Loader2 className="w-3 h-3 animate-spin" />
                        ⏳ {action.label} processing...
                      </div>
                      {hash && (
                        <div className="flex items-center gap-2 text-xs">
                          <span className="font-mono bg-black/20 px-2 py-1 rounded">
                            {formatAddress(hash)}
                          </span>
                          <a
                            href={getExplorerUrl(hash)}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="flex items-center gap-1 hover:underline"
                          >
                            <ExternalLink className="w-3 h-3" />
                            View Live
                          </a>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </CardContent>
    </Card>
  );
}
