# Starting Your Pruned Bitcoin Mainnet Node

## 🚀 启动节点

### 1. 使用已构建的Bitcoin Core
```bash
# 如果您已经构建了Bitcoin Core（从build目录）
cd build
./bin/bitcoind

# 或者后台运行
./bin/bitcoind -daemon
```

### 2. 使用官方Bitcoin Core二进制文件
```bash
# 如果您下载了官方版本
bitcoind

# 或者后台运行
bitcoind -daemon
```

### 3. 指定配置文件（如果放在非默认位置）
```bash
./bin/bitcoind -conf=/path/to/your/bitcoin.conf
```

## 📊 监控节点状态

### 检查区块链同步状态
```bash
# 获取区块链信息
./bin/bitcoin-cli getblockchaininfo

# 查看同步进度
./bin/bitcoin-cli getblockchaininfo | grep -E "(blocks|headers|verificationprogress)"
```

### 查看网络连接
```bash
# 查看连接的节点数量
./bin/bitcoin-cli getconnectioncount

# 查看具体连接信息
./bin/bitcoin-cli getpeerinfo
```

### 检查修剪状态
```bash
# 查看修剪相关信息
./bin/bitcoin-cli getblockchaininfo | grep -E "(pruned|pruneheight|size_on_disk)"
```

### 监控内存和磁盘使用
```bash
# 查看数据目录大小
du -sh ~/Library/Application\ Support/Bitcoin/

# 实时监控日志
tail -f ~/Library/Application\ Support/Bitcoin/debug.log
```

## 📈 预期的存储使用

### 修剪节点存储需求：
- **初始下载**: ~500GB（临时，会被修剪）
- **修剪后稳定状态**: 2-5GB（取决于prune设置）
- **钱包数据**: 几MB到几GB（取决于交易数量）
- **其他数据**: ~1GB（chainstate、peers.dat等）

### 同步时间估算：
- **初次同步**: 几小时到几天（取决于网络和硬件）
- **后续启动**: 几分钟

## ⚠️ 重要注意事项

### 1. 修剪节点的限制：
- **不能重新扫描旧区块**（如果导入旧钱包）
- **不能为其他节点提供历史区块**
- **某些钱包功能可能受限**

### 2. 网络要求：
- **初次同步**: 500GB+ 下载
- **日常运行**: 几GB/月

### 3. 如果需要更少存储：
```bash
# 最小修剪设置（550MB）
prune=550

# 或者考虑使用轻客户端
# Bitcoin Core不支持SPV，但可以考虑：
# - Electrum (SPV客户端)
# - 使用远程节点连接
```

## 🛠️ 有用的命令

### 停止节点
```bash
./bin/bitcoin-cli stop
```

### 重启同步（如果遇到问题）
```bash
# 停止节点
./bin/bitcoin-cli stop

# 删除不完整的区块数据（谨慎使用）
rm -rf ~/Library/Application\ Support/Bitcoin/blocks/
rm -rf ~/Library/Application\ Support/Bitcoin/chainstate/

# 重新启动
./bin/bitcoind -daemon
```

### 检查钱包余额（如果启用钱包）
```bash
./bin/bitcoin-cli getwalletinfo
./bin/bitcoin-cli getbalance
```

## 🎯 成功指标

当您看到以下情况时，说明设置成功：
- `getblockchaininfo` 显示 `"verificationprogress": 0.99999...`
- `"pruned": true` 在区块链信息中
- 数据目录大小保持在预期范围内
- 能够创建钱包和接收地址

这样您就可以连接到Bitcoin主网而不占用太多存储空间！ 