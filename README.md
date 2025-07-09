# Walrus Blob Storage Learning Repository

A comprehensive learning and testing repository for Sui blockchain's Walrus decentralized storage system.

## 🌊 What is Walrus?

Walrus is a decentralized storage and data availability protocol designed specifically for large binary files ("blobs"). It's built on the Sui blockchain and provides:

- **Decentralized Storage**: Store large files across a network of storage nodes
- **Fault Tolerance**: Uses advanced erasure coding to maintain data availability even with Byzantine faults
- **Blockchain Integration**: Leverages Sui for coordination, payments, and governance
- **Cost Efficiency**: ~5x storage cost compared to traditional replication methods
- **Flexible Access**: CLI, TypeScript SDK, HTTP API, and web2 technologies

## 🏗️ Repository Structure

```
.
├── README.md                    # This file
├── docs/                        # Documentation and learning materials
│   ├── getting-started.md       # Step-by-step setup guide
│   ├── concepts.md             # Core concepts and architecture
│   ├── api-reference.md        # API reference and examples
│   └── troubleshooting.md      # Common issues and solutions
├── examples/                   # Practical examples and tutorials
│   ├── typescript/            # TypeScript SDK examples
│   ├── python/               # Python examples using HTTP API
│   ├── cli/                  # Command-line interface examples
│   ├── web-app/              # Web application integration
│   └── walrus-sites/         # Decentralized websites examples
├── scripts/                   # Utility scripts
│   ├── setup.sh             # Environment setup script
│   ├── test-blob-operations.sh # Test blob storage and retrieval
│   └── deploy-example.sh     # Deploy example applications
├── config/                   # Configuration files
│   ├── testnet.yaml         # Testnet configuration
│   └── mainnet.yaml         # Mainnet configuration
├── test-data/               # Sample files for testing
├── tools/                   # Custom tools and utilities
└── package.json            # Node.js dependencies
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and npm/pnpm
- Sui CLI installed
- Git

### Setup

1. Clone and navigate to this repository
2. Install dependencies:
   ```bash
   npm install
   # or
   pnpm install
   ```

3. Set up your Sui wallet and get testnet tokens:
   ```bash
   # Create a new wallet
   sui client new-address ed25519
   
   # Get testnet tokens
   sui client faucet
   ```

4. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

### First Blob Storage

Try storing your first blob:

```bash
# Using CLI
cd examples/cli
./store-first-blob.sh

# Using TypeScript
cd examples/typescript
npm run basic-example

# Using Python
cd examples/python
python basic_example.py
```

## 📚 Learning Path

### 1. **Understand the Basics** (`docs/concepts.md`)
- Learn about blob storage concepts
- Understand erasure coding and fault tolerance
- Explore the Sui blockchain integration

### 2. **Get Hands-On** (`examples/`)
- Start with simple CLI examples
- Progress to TypeScript SDK usage
- Build a web application integration

### 3. **Advanced Topics**
- Implement aggregators and publishers
- Create decentralized websites with Walrus Sites
- Build custom storage solutions

## 🔧 Available Examples

### TypeScript SDK
- **Basic Operations**: Store and retrieve blobs
- **Advanced Features**: Fan-out proxies, error handling
- **Web Integration**: Browser-based blob operations
- **Aggregator/Publisher**: Custom storage services

### Python HTTP API
- **REST API Usage**: Direct HTTP API interactions
- **File Upload/Download**: Handle large files
- **Batch Operations**: Process multiple blobs

### CLI Examples
- **Command Reference**: All CLI commands with examples
- **Scripted Operations**: Automated blob management
- **Configuration**: Network and storage settings

### Web Applications
- **React Integration**: Frontend blob storage
- **File Manager**: Full-featured file management UI
- **Image Gallery**: Decentralized image storage

### Walrus Sites
- **Static Website**: Deploy static sites to Walrus
- **Dynamic Content**: Interactive decentralized applications
- **NFT Galleries**: Per-NFT websites

## 🌐 Official Resources

- **Main Repository**: https://github.com/MystenLabs/walrus
- **Documentation**: https://docs.walrus.site/
- **TypeScript SDK**: https://sdk.mystenlabs.com/walrus
- **Sui Documentation**: https://docs.sui.io/
- **Community**: https://discord.gg/sui

## 🛠️ Development

### Testing
```bash
# Run all tests
npm test

# Test specific examples
npm run test:typescript
npm run test:python
npm run test:cli
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Add examples or improvements
4. Submit a pull request

## 🐛 Issues & Support

- Check `docs/troubleshooting.md` for common issues
- Review examples for implementation patterns
- Join the Sui Discord for community support
- Report issues in the main Walrus repository

## 📄 License

This learning repository is provided under the MIT License. See LICENSE file for details.

## 🎯 Next Steps

1. **Complete the Quick Start** to get your environment ready
2. **Explore Examples** to understand different use cases
3. **Build Something** - try creating your own blob storage application
4. **Join the Community** - connect with other Walrus developers

---

*Happy coding with Walrus! 🌊*