# Bitcoin Core - Developer Onboarding Guide

Welcome to Bitcoin Core development! This guide will help you understand what Bitcoin Core is and how to get started contributing.

## 🎯 What is Bitcoin Core?

**Bitcoin Core** is the reference implementation of the Bitcoin protocol. It's the software that:

- **Validates** all Bitcoin transactions and blocks
- **Maintains** the complete Bitcoin blockchain
- **Provides** wallet functionality for managing Bitcoin
- **Implements** the peer-to-peer network protocol
- **Serves** as the foundation that other Bitcoin software builds upon

Think of it as the "official" Bitcoin software that defines how Bitcoin actually works.

## 🏗️ High-Level Architecture

Bitcoin Core consists of several key components working together:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Bitcoin CLI   │    │   Bitcoin QT    │    │  Bitcoin Wallet │
│  (Command Line) │    │      (GUI)      │    │     (Tool)      │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────▼──────────────┐
                    │        Bitcoin Core        │
                    │        (bitcoind)          │
                    └─────────────┬──────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        │                         │                         │
┌───────▼────────┐    ┌──────────▼───────────┐    ┌────────▼────────┐
│   P2P Network  │    │     Validation       │    │   Wallet Engine │
│   (Networking) │    │   (Consensus Rules)  │    │  (Key Management)│
└────────────────┘    └──────────────────────┘    └─────────────────┘
        │                         │                         │
        │              ┌──────────▼───────────┐             │
        │              │      Database        │             │
        │              │   (Blockchain Data)  │             │
        │              └──────────────────────┘             │
        │                                                   │
        └───────────────────────┬───────────────────────────┘
                                │
                    ┌───────────▼────────────┐
                    │      File System       │
                    │  (blocks/, chainstate/,│
                    │     wallets/, etc.)    │
                    └────────────────────────┘
```

## 🧩 Key Components

### 1. **bitcoind** - The Core Daemon
- Heart of Bitcoin Core
- Validates transactions and blocks
- Maintains the blockchain
- Handles peer-to-peer networking
- Provides RPC API for other tools

### 2. **bitcoin-cli** - Command Line Interface  
- Talks to bitcoind via RPC
- Used for wallet operations, queries, administration
- Great for scripting and automation

### 3. **bitcoin-wallet** - Wallet Management Tool
- Standalone wallet operations
- Create, backup, restore wallets
- Works without running bitcoind

### 4. **bitcoin-qt** - Graphical Interface
- Desktop GUI application
- User-friendly interface for non-technical users
- Includes wallet functionality

### 5. **bitcoin-util** - Utility Tool
- Various helper functions
- Block/transaction analysis
- Development utilities

## 📁 Source Code Structure

Understanding the codebase layout:

```
bitcoin/
├── src/                    # Main source code (C++)
│   ├── wallet/            # Wallet implementation
│   ├── net/               # Networking code
│   ├── consensus/         # Consensus rules
│   ├── script/            # Script execution
│   ├── primitives/        # Basic data structures
│   ├── crypto/            # Cryptographic functions
│   ├── rpc/               # RPC server implementation
│   ├── test/              # Unit tests
│   └── qt/                # GUI code
│
├── test/                   # Test infrastructure
│   ├── functional/        # End-to-end tests (Python)
│   ├── fuzz/              # Fuzzing tests
│   └── lint/              # Code style checks
│
├── doc/                    # Documentation
├── contrib/                # Build scripts and tools
├── build/                  # Build directory (after cmake)
└── depends/                # Dependency management
```

## 🔑 Core Concepts You Should Know

### 1. **Consensus Rules**
- Rules that all Bitcoin nodes must agree on
- Define what makes a valid block/transaction
- Changes require network-wide agreement
- Located in `src/consensus/`

### 2. **Script System**
- Bitcoin's programming language
- Controls how Bitcoin can be spent
- Stack-based, simple operations
- Found in `src/script/`

### 3. **Peer-to-Peer Network**
- How Bitcoin nodes communicate
- Handles block/transaction propagation
- Manages connections to other nodes
- Implemented in `src/net/`

### 4. **Wallet**
- Manages private keys and addresses
- Creates and signs transactions
- Tracks balances and transaction history
- Code in `src/wallet/`

### 5. **Database Layer**
- Stores blockchain data efficiently
- Uses LevelDB for chainstate
- SQLite for wallet data
- File-based block storage

## 🚀 Getting Started - First Steps

### 1. **Set Up Development Environment**
```bash
# Clone the repository
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin

# Install dependencies (Ubuntu/Debian)
sudo apt update
sudo apt install build-essential cmake pkg-config bsdmainutils python3

# macOS with Homebrew
brew install cmake pkg-config
```

### 2. **Build Bitcoin Core**
```bash
# Configure and build
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)
```

### 3. **Run Your First Tests**
```bash
# Unit tests
./bin/test_bitcoin

# Functional tests (a few quick ones)
../test/functional/wallet_basic.py
../test/functional/example_test.py
```

### 4. **Start Exploring**
```bash
# Start in regtest mode (safe for development)
./bin/bitcoind -regtest -daemon

# Create a wallet
./bin/bitcoin-cli -regtest createwallet "test"

# Generate some blocks
./bin/bitcoin-cli -regtest generatetoaddress 101 $(./bin/bitcoin-cli -regtest getnewaddress)

# Check the balance
./bin/bitcoin-cli -regtest getbalance
```

## 🧪 Testing Philosophy

Bitcoin Core has extensive testing because bugs can be catastrophic:

### **Test Types:**
1. **Unit Tests** (`src/test/`) - Test individual functions/classes
2. **Functional Tests** (`test/functional/`) - Test complete workflows
3. **Fuzz Tests** (`test/fuzz/`) - Find edge cases with random input
4. **Integration Tests** - Test component interactions

### **Test-Driven Development:**
- Write tests for new features
- Ensure tests fail before implementing
- Make tests pass with minimal code
- Refactor while keeping tests green

## 💡 Development Best Practices

### **Code Style:**
- Follow existing conventions
- Run linters: `test/lint/lint-all.py`
- Keep changes minimal and focused
- Use meaningful variable names

### **Commit Messages:**
```
component: brief description

Longer explanation of what this change does and why it's needed.
Can span multiple lines and include technical details.
```

### **Pull Request Process:**
1. Create feature branch from master
2. Make focused, atomic commits  
3. Write comprehensive tests
4. Update documentation if needed
5. Open PR with clear description
6. Address review feedback
7. Squash commits if requested

### **Safety First:**
- Always test on regtest first
- Never test with real Bitcoin on mainnet
- Understand consensus implications
- Get review for any consensus changes

## 🌟 Areas for Contribution

### **Good First Issues:**
- Documentation improvements
- Test coverage expansion
- Code cleanup and refactoring
- Build system improvements
- GUI enhancements

### **Advanced Areas:**
- Consensus rule changes
- P2P protocol improvements
- Wallet functionality
- Performance optimizations
- Security enhancements

## 🔍 How to Find Your Way Around

### **When looking for code:**
1. **Start with tests** - they show how things work
2. **Follow RPC commands** - see how CLI translates to internal functions
3. **Use grep** - search for function names or error messages
4. **Check git history** - see how features evolved

### **Useful grep patterns:**
```bash
# Find RPC command implementation
grep -r "getnewaddress" src/

# Find test for specific functionality  
grep -r "test.*wallet.*create" test/

# Find consensus rules
grep -r "MAX_BLOCK_SIZE" src/consensus/
```

## 🎓 Learning Resources

### **Essential Reading:**
- [Bitcoin Whitepaper](https://bitcoin.org/bitcoin.pdf)
- [Developer Documentation](https://bitcoincore.org/en/doc/)
- [BIP (Bitcoin Improvement Proposals)](https://github.com/bitcoin/bips)

### **Code Understanding:**
- Start with `test/functional/example_test.py`
- Read `src/rpc/` to understand API
- Explore `src/primitives/` for basic structures
- Study `src/consensus/` for rules

### **Community:**
- #bitcoin-core-dev on Libera Chat IRC
- Bitcoin Core development meetings
- Bitcoin StackExchange for questions
- GitHub issues and PRs

## ⚠️ Important Warnings

1. **Never use development builds with real Bitcoin**
2. **Consensus changes require extreme care**
3. **Always backup wallets before testing**
4. **Understand the difference between testnet, regtest, and mainnet**
5. **Security vulnerabilities should be reported privately**

## 🎯 Your First Contribution Goal

**Suggested path:**
1. ✅ Build Bitcoin Core successfully
2. ✅ Run unit and functional tests
3. ✅ Start bitcoind in regtest mode
4. ✅ Create and fund a test wallet
5. ✅ Read through a simple functional test
6. ✅ Find a "good first issue" on GitHub
7. ✅ Make a small documentation improvement
8. ✅ Submit your first pull request

Remember: Bitcoin Core development is about precision, testing, and safety. Take your time to understand how things work before making changes. The community is helpful, but everyone shares the responsibility of maintaining the world's most important cryptocurrency software.

Welcome to Bitcoin development! 🚀 