# Bitcoin Core Pruning Reference Guide

## 🗜️ Pruning Modes

### What is Pruning?
Pruning allows Bitcoin Core to delete old block data after validating it, keeping only recent blocks. The node still validates everything but saves storage space.

## 📐 Pruning Size Options

### Command Line Arguments:
```bash
# Minimum pruning (550MB)
./bin/bitcoind -prune=550

# Recommended pruning (2GB) 
./bin/bitcoind -prune=2000

# Custom size (5GB)
./bin/bitcoind -prune=5000

# With optimizations
./bin/bitcoind -prune=2000 -maxconnections=8 -dbcache=100 -maxuploadtarget=1000
```

### Configuration File Options:
```bash
# In bitcoin.conf:
prune=2000                 # Enable pruning with 2GB limit
# OR
prune=1                    # Enable automatic pruning (uses default ~550MB)
```

## 🎯 Pruning Levels

| Size | Storage | Use Case |
|------|---------|----------|
| `prune=550` | ~550MB | Absolute minimum |
| `prune=1000` | ~1GB | Light usage |
| `prune=2000` | ~2GB | **Recommended** |
| `prune=5000` | ~5GB | More historical data |
| `prune=10000` | ~10GB | Extended history |

## 🚀 Starting Methods

### 1. Command Line Only:
```bash
# Start with pruning
./bin/bitcoind -prune=2000 -daemon

# Stop node
./bin/bitcoin-cli stop

# Restart with different pruning
./bin/bitcoind -prune=1000 -daemon
```

### 2. With Config File:
```bash
# Create config file with prune=2000
echo "prune=2000" > ~/Library/Application\ Support/Bitcoin/bitcoin.conf

# Start normally (reads config)
./bin/bitcoind -daemon
```

### 3. Mixed (Config + Command Line):
```bash
# Config file has basic settings
# Command line overrides specific options
./bin/bitcoind -daemon -prune=5000  # Overrides config file prune setting
```

## ⚠️ Important Notes

### Pruning Limitations:
- ❌ **Cannot rescan old blocks** (if importing old wallets)
- ❌ **Cannot serve historical blocks** to other nodes
- ❌ **Some wallet recovery features limited**
- ✅ **Full validation** still occurs
- ✅ **All current functionality** works
- ✅ **Can upgrade to full node** later

### Changing Pruning Settings:
```bash
# To change pruning size, you must restart bitcoind
./bin/bitcoin-cli stop
./bin/bitcoind -prune=5000 -daemon  # New size
```

### Disabling Pruning (Convert to Full Node):
```bash
# Stop pruned node
./bin/bitcoin-cli stop

# Remove pruning and redownload everything (WARNING: Takes days)
./bin/bitcoind -daemon  # No -prune argument

# Or explicitly disable in config:
# prune=0  # In bitcoin.conf
```

## 📊 Monitoring Pruned Nodes

### Check Pruning Status:
```bash
# Show pruning info
./bin/bitcoin-cli getblockchaininfo | grep -E "(pruned|prune)"

# Current storage usage
du -sh ~/Library/Application\ Support/Bitcoin/
```

### Key Fields in getblockchaininfo:
```json
{
  "pruned": true,                    // Pruning enabled
  "pruneheight": 845000,            // Oldest block kept
  "prune_target_size": 2097152000,  // Target size in bytes (2GB)
  "size_on_disk": 1987654321        // Current actual size
}
```

## 🎯 Recommended Configurations

### For Developers:
```bash
./bin/bitcoind -prune=2000 -daemon -maxconnections=8 -dbcache=200
```

### For Minimal Systems:
```bash
./bin/bitcoind -prune=550 -daemon -maxconnections=4 -dbcache=50
```

### For Better Performance:
```bash
./bin/bitcoind -prune=5000 -daemon -maxconnections=16 -dbcache=500
```

## 🛠️ Troubleshooting

### If Pruning Fails:
```bash
# Check disk space
df -h

# Check config
./bin/bitcoin-cli getblockchaininfo

# Restart with explicit settings
./bin/bitcoin-cli stop
./bin/bitcoind -prune=2000 -daemon
```

### Common Issues:
1. **"Insufficient space"** - Increase prune value or free disk space
2. **"Cannot decrease prune"** - Must restart with smaller value
3. **"Wallet rescan failed"** - Pruning prevents rescanning old blocks

This covers all the essential pruning options for Bitcoin Core! 