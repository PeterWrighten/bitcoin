#!/bin/bash

# Bitcoin Core Network & Thread Monitor
# Shows comprehensive status of Bitcoin Core networking and threads

echo "=== Bitcoin Core Network & Thread Status ==="
echo "Time: $(date)"
echo

# Check if bitcoind is running
MAIN_PID=$(ps aux | grep bitcoind | grep -v grep | grep prune | awk '{print $2}' | head -1)

if [ -z "$MAIN_PID" ]; then
    echo "❌ No pruned bitcoind process found!"
    exit 1
fi

echo "✅ Bitcoin Core Process ID: $MAIN_PID"
echo

# === NETWORK STATUS ===
echo "🌐 NETWORK STATUS"
echo "════════════════="

# Basic network info
NETWORK_INFO=$(./bin/bitcoin-cli getnetworkinfo 2>/dev/null)
if [ $? -eq 0 ]; then
    VERSION=$(echo "$NETWORK_INFO" | grep '"version"' | cut -d':' -f2 | tr -d ' ,')
    CONNECTIONS=$(echo "$NETWORK_INFO" | grep '"connections"' | head -1 | cut -d':' -f2 | tr -d ' ,')
    CONNECTIONS_IN=$(echo "$NETWORK_INFO" | grep '"connections_in"' | cut -d':' -f2 | tr -d ' ,')
    CONNECTIONS_OUT=$(echo "$NETWORK_INFO" | grep '"connections_out"' | cut -d':' -f2 | tr -d ' ,')
    NETWORK_ACTIVE=$(echo "$NETWORK_INFO" | grep '"networkactive"' | cut -d':' -f2 | tr -d ' ,')
    
    echo "   Version: $VERSION"
    echo "   Network Active: $NETWORK_ACTIVE"
    echo "   Total Connections: $CONNECTIONS"
    echo "   Inbound: $CONNECTIONS_IN"
    echo "   Outbound: $CONNECTIONS_OUT"
else
    echo "   ❌ Cannot connect to Bitcoin RPC"
fi

echo

# Peer connection summary
echo "📡 PEER CONNECTIONS"
echo "═══════════════════"
PEER_INFO=$(./bin/bitcoin-cli getpeerinfo 2>/dev/null)
if [ $? -eq 0 ]; then
    PEER_COUNT=$(echo "$PEER_INFO" | grep '"id"' | wc -l | tr -d ' ')
    echo "   Connected Peers: $PEER_COUNT"
    
    # Show peer locations and versions (first 5)
    echo "   Recent Peers:"
    echo "$PEER_INFO" | grep -E '"addr"|"subver"' | head -10 | while IFS= read -r line; do
        if [[ $line == *"addr"* ]]; then
            ADDR=$(echo "$line" | cut -d'"' -f4)
            echo "     • $ADDR"
        elif [[ $line == *"subver"* ]]; then
            SUBVER=$(echo "$line" | cut -d'"' -f4)
            echo "       Version: $SUBVER"
        fi
    done
else
    echo "   ❌ Cannot get peer information"
fi

echo

# === THREAD STATUS ===
echo "🧵 THREAD STATUS"
echo "═══════════════="

# Thread count from system
THREAD_COUNT=$(ps -M $MAIN_PID 2>/dev/null | wc -l | tr -d ' ')
THREAD_COUNT=$((THREAD_COUNT - 1))  # Subtract header line

echo "   Process ID: $MAIN_PID"
echo "   Total Threads: $THREAD_COUNT"

# Active threads with CPU usage
echo "   Active Threads (with CPU > 0%):"
ps -M $MAIN_PID 2>/dev/null | awk 'NR>1 && $4>0 {printf "     Thread: %s%% CPU, %s STIME, %s UTIME\n", $4, $7, $8}' | head -5

echo

# Bitcoin Core specific threads from debug log
echo "🔧 BITCOIN CORE THREADS"
echo "══════════════════════"
echo "   Known Bitcoin threads from logs:"

# Check for recent thread messages
THREAD_LOGS=$(grep -i "thread" ~/Library/Application\ Support/Bitcoin/debug.log 2>/dev/null | tail -10)
if [ ! -z "$THREAD_LOGS" ]; then
    echo "$THREAD_LOGS" | grep -E "(start|exit)" | tail -8 | while IFS= read -r line; do
        TIMESTAMP=$(echo "$line" | cut -d' ' -f1)
        THREAD_INFO=$(echo "$line" | cut -d' ' -f3-)
        echo "     [$TIMESTAMP] $THREAD_INFO"
    done
else
    echo "     ❌ Cannot read debug log"
fi

echo

# === SYSTEM RESOURCES ===
echo "💾 SYSTEM RESOURCES"
echo "═══════════════════"

# CPU and Memory for the process
PROCESS_INFO=$(ps -p $MAIN_PID -o pid,pcpu,pmem,vsz,rss 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "$PROCESS_INFO" | tail -1 | while read PID CPU MEM VSZ RSS; do
        RSS_MB=$((RSS / 1024))
        VSZ_MB=$((VSZ / 1024))
        echo "   CPU Usage: ${CPU}%"
        echo "   Memory: ${MEM}% (${RSS_MB}MB RSS, ${VSZ_MB}MB VSZ)"
    done
else
    echo "   ❌ Cannot get process information"
fi

# Disk usage
DATA_SIZE=$(du -sh ~/Library/Application\ Support/Bitcoin/ 2>/dev/null | cut -f1)
echo "   Bitcoin Data Size: $DATA_SIZE"

# Network activity (bytes sent/received)
if [ ! -z "$PEER_INFO" ]; then
    TOTAL_SENT=$(echo "$PEER_INFO" | grep '"bytessent"' | awk -F: '{sum+=$2} END {gsub(/[^0-9]/, "", sum); print sum}')
    TOTAL_RECV=$(echo "$PEER_INFO" | grep '"bytesrecv"' | awk -F: '{sum+=$2} END {gsub(/[^0-9]/, "", sum); print sum}')
    
    if [ ! -z "$TOTAL_SENT" ] && [ ! -z "$TOTAL_RECV" ]; then
        SENT_MB=$((TOTAL_SENT / 1024 / 1024))
        RECV_MB=$((TOTAL_RECV / 1024 / 1024))
        echo "   Network: ${SENT_MB}MB sent, ${RECV_MB}MB received"
    fi
fi

echo

# === USEFUL COMMANDS ===
echo "🛠️  USEFUL COMMANDS"
echo "══════════════════"
echo "   Monitor this info: watch -n 30 ./network_threads_monitor.sh"
echo "   Network details:   ./bin/bitcoin-cli getnetworkinfo"
echo "   Peer details:      ./bin/bitcoin-cli getpeerinfo"
echo "   Live debug log:    tail -f ~/Library/Application\ Support/Bitcoin/debug.log"
echo "   Process threads:   ps -M $MAIN_PID"
echo "   Top for bitcoind:  top -pid $MAIN_PID"

echo
echo "=== End Status ===" 