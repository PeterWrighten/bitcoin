#!/bin/bash

# Bitcoin Core Sync Monitor Script
# Run this script to check your node's sync progress

echo "=== Bitcoin Core Pruned Node Status ==="
echo "Time: $(date)"
echo

# Check if bitcoind is running
if ! ./bin/bitcoin-cli getblockchaininfo >/dev/null 2>&1; then
    echo "❌ Bitcoin Core is not running!"
    echo "Start it with: ./bin/bitcoind -daemon"
fi

echo "✅ Bitcoin Core is running"
echo

# Get blockchain info
BLOCKCHAIN_INFO=$(./bin/bitcoin-cli getblockchaininfo)
BLOCKS=$(echo "$BLOCKCHAIN_INFO" | grep '"blocks"' | cut -d':' -f2 | tr -d ' ,')
HEADERS=$(echo "$BLOCKCHAIN_INFO" | grep '"headers"' | cut -d':' -f2 | tr -d ' ,')
PROGRESS=$(echo "$BLOCKCHAIN_INFO" | grep '"verificationprogress"' | cut -d':' -f2 | tr -d ' ,')
PRUNED=$(echo "$BLOCKCHAIN_INFO" | grep '"pruned"' | cut -d':' -f2 | tr -d ' ,')

# Convert progress to percentage
PROGRESS_PERCENT=$(echo "$PROGRESS * 100" | bc -l | cut -d'.' -f1)

echo "📊 Sync Progress:"
echo "   Blocks downloaded: $BLOCKS"
echo "   Headers downloaded: $HEADERS"
echo "   Sync progress: ${PROGRESS_PERCENT}%"
echo "   Pruning enabled: $PRUNED"
echo

# Network info
CONNECTIONS=$(./bin/bitcoin-cli getconnectioncount)
echo "🌐 Network:"
echo "   Connected peers: $CONNECTIONS"
echo

# Disk usage
DATA_SIZE=$(du -sh ~/Library/Application\ Support/Bitcoin/ | cut -f1)
echo "💾 Storage:"
echo "   Data directory size: $DATA_SIZE"
echo "   Pruning target: 2GB (will maintain this size after full sync)"
echo

# Estimate time remaining (rough calculation)
if [ "$BLOCKS" -gt 0 ] && [ "$HEADERS" -gt 0 ]; then
    if [ "$HEADERS" -gt "$BLOCKS" ]; then
        REMAINING_BLOCKS=$((HEADERS - BLOCKS))
        echo "⏱️  Estimated remaining blocks: $REMAINING_BLOCKS"
    else
        echo "🎉 Block download complete! Verifying..."
    fi
fi

echo
echo "💡 Tips:"
echo "   - Initial sync can take several hours to days"
echo "   - Monitor with: watch -n 30 ./monitor_sync.sh"
echo "   - Check logs: tail -f ~/Library/Application\ Support/Bitcoin/debug.log"
# echo "   - Stop node: ./bin/bitcoin-cli stop"
echo
echo "=== End Status ==="
