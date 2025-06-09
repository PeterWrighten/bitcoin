# Bitcoin Core - Essential Commands Reference

This document provides quick reference for common Bitcoin Core development commands.

## 🏗️ Building

### Initial Setup (CMake)
```bash
# Create build directory
mkdir build && cd build

# Configure build (Release)
cmake .. -DCMAKE_BUILD_TYPE=Release

# Configure build (Debug)
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Configure with specific options
cmake .. -DCMAKE_BUILD_TYPE=Debug \
         -DWITH_ZMQ=ON \
         -DENABLE_WALLET=ON \
         -DBUILD_TESTS=ON
```

### Building
```bash
# Build everything (from build/ directory)
make -j$(nproc)

# Build specific targets
make bitcoind          # Bitcoin daemon
make bitcoin-cli       # Command line interface
make bitcoin-wallet    # Wallet tool
make bitcoin-util      # Utility tool
make test_bitcoin      # Unit tests

# Clean build
make clean
```

## 🏃 Running

### Bitcoin Daemon
```bash
# Start bitcoind (mainnet)
./bin/bitcoind

# Start with regtest (local testing)
./bin/bitcoind -regtest

# Start with testnet
./bin/bitcoind -testnet

# Start with custom datadir
./bin/bitcoind -datadir=/custom/path

# Run in background
./bin/bitcoind -daemon

# Stop daemon
./bin/bitcoin-cli stop
```

### Bitcoin CLI (Command Line Interface)
```bash
# Basic info
./bin/bitcoin-cli getblockchaininfo
./bin/bitcoin-cli getwalletinfo
./bin/bitcoin-cli getpeerinfo

# Wallet operations
./bin/bitcoin-cli getnewaddress
./bin/bitcoin-cli getbalance
./bin/bitcoin-cli sendtoaddress <address> <amount>

# With regtest
./bin/bitcoin-cli -regtest getblockchaininfo

# Generate blocks (regtest only)
./bin/bitcoin-cli -regtest generatetoaddress 101 <address>
```

### Bitcoin Wallet Tool
```bash
# Get wallet info
./bin/bitcoin-wallet -wallet=mywallet info

# Create wallet
./bin/bitcoin-wallet -wallet=mywallet create

# Dump wallet
./bin/bitcoin-wallet -wallet=mywallet -dumpfile=backup.dump dump

# Create from dump
./bin/bitcoin-wallet -wallet=restored -dumpfile=backup.dump createfromdump
```

## 🧪 Testing

### Unit Tests
```bash
# Run all unit tests
./bin/test_bitcoin

# Run specific test suite
./bin/test_bitcoin -t wallet_tests
./bin/test_bitcoin -t db_tests

# Run with verbose output
./bin/test_bitcoin --log_level=all

# List available test suites
./bin/test_bitcoin --list_content
```

### Functional Tests
```bash
# Run all functional tests
test/functional/test_runner.py

# Run specific test
test/functional/wallet_basic.py
test/functional/tool_wallet.py

# Run multiple tests
test/functional/test_runner.py wallet_basic.py wallet_multiwallet.py

# Run with different parallelism
test/functional/test_runner.py -j 4

# Run extended tests (slow)
test/functional/test_runner.py --extended

# Run without wallet tests
test/functional/test_runner.py --exclude wallet

# Run specific test with debug output
test/functional/wallet_basic.py --loglevel=debug
```

### Test Categories
```bash
# Wallet tests
test/functional/test_runner.py wallet_*

# RPC tests  
test/functional/test_runner.py rpc_*

# P2P networking tests
test/functional/test_runner.py p2p_*

# Feature tests
test/functional/test_runner.py feature_*

# Tool tests
test/functional/test_runner.py tool_*
```

## 🔧 Development Workflow

### Git Commands
```bash
# Create feature branch
git checkout -b my-feature-branch

# Stage and commit changes
git add .
git commit -m "descriptive commit message"

# Push to origin
git push origin my-feature-branch

# Rebase on master
git rebase master

# Interactive rebase (squash commits)
git rebase -i HEAD~3
```

### Code Formatting & Linting
```bash
# Check Python code style
test/lint/lint-python.py

# Check shell scripts
test/lint/lint-shell.py

# Check whitespace
test/lint/lint-whitespace.py

# Check circular dependencies
test/lint/lint-circular-dependencies.py

# Run all linters
test/lint/lint-all.py
```

### Useful Development Commands
```bash
# Find Bitcoin-related processes
ps aux | grep bitcoin

# Kill all Bitcoin processes
pkill bitcoind
pkill bitcoin-cli

# Clean up test directories
rm -rf /tmp/bitcoin_func_test_*

# Check disk usage
du -sh ~/.bitcoin/
du -sh build/
```

## 🐛 Debugging

### Debug Build & Run
```bash
# Build with debug symbols
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)

# Run with debug output
./bin/bitcoind -debug

# Run with specific debug categories
./bin/bitcoind -debug=net,http,rpc

# Run with gdb
gdb --args ./bin/bitcoind -regtest
```

### Log Analysis
```bash
# Monitor debug.log
tail -f ~/.bitcoin/debug.log

# Search for errors
grep -i error ~/.bitcoin/debug.log

# Filter by category
grep "http:" ~/.bitcoin/debug.log
```

## 📊 Performance & Benchmarking

### Benchmarks
```bash
# Run all benchmarks
./bin/bench_bitcoin

# Run specific benchmark
./bin/bench_bitcoin -filter=".*wallet.*"

# Run with iterations
./bin/bench_bitcoin -min_time=1000
```

### Profiling
```bash
# Build with profiling
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)

# Run with perf
perf record ./bin/bitcoind
perf report
```

## 🌐 Network Commands

### Regtest Network
```bash
# Start regtest
./bin/bitcoind -regtest -daemon

# Create wallet
./bin/bitcoin-cli -regtest createwallet "test"

# Generate initial blocks
./bin/bitcoin-cli -regtest generatetoaddress 101 $(./bin/bitcoin-cli -regtest getnewaddress)

# Send transaction
./bin/bitcoin-cli -regtest sendtoaddress <address> 10

# Mine block with transaction
./bin/bitcoin-cli -regtest generatetoaddress 1 <mining_address>
```

### Testnet
```bash
# Start testnet
./bin/bitcoind -testnet -daemon

# Get testnet coins (use faucet websites)
# Example: https://testnet-faucet.mempool.co/
```

## 📁 Important Paths

### Default Data Directories
```bash
# Linux
~/.bitcoin/

# macOS  
~/Library/Application Support/Bitcoin/

# Windows
%APPDATA%\Bitcoin\
```

### Build Artifacts
```bash
build/bin/          # Executables
build/lib/          # Libraries  
build/test/         # Test binaries
```

### Source Structure
```bash
src/                # Main source code
src/wallet/         # Wallet implementation
src/test/          # Unit tests
test/functional/   # Functional tests
doc/               # Documentation
contrib/           # Utilities and scripts
```

## 💡 Tips

1. **Always test locally** before submitting PRs
2. **Use regtest** for development - it's fast and isolated
3. **Run linters** before committing
4. **Check functional tests** for examples of API usage
5. **Monitor debug.log** when debugging issues
6. **Use meaningful commit messages** following project conventions
7. **Keep commits atomic** - one logical change per commit

## 🚀 Quick Start Workflow

```bash
# 1. Build
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)

# 2. Test
./bin/test_bitcoin
cd .. && test/functional/test_runner.py

# 3. Run regtest
./bin/bitcoind -regtest -daemon
./bin/bitcoin-cli -regtest createwallet "dev"

# 4. Development cycle
# - Make changes
# - Run relevant tests
# - Commit and push
```

This covers the most commonly used commands for Bitcoin Core development! 