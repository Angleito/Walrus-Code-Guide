# Getting Started with Walrus

This guide will help you set up your environment and start using Walrus for decentralized blob storage.

## Prerequisites

Before you begin, ensure you have:

1. **Node.js 18+** and npm/pnpm installed
2. **Sui CLI** installed and configured
3. **Git** for version control
4. **Basic understanding** of blockchain concepts

## Installation

### 1. Install Sui CLI

```bash
# Install using cargo
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch testnet sui

# Or download binary from releases
# https://github.com/MystenLabs/sui/releases
```

### 2. Set Up Sui Wallet

```bash
# Initialize Sui configuration
sui client

# Create a new address
sui client new-address ed25519

# Set the new address as active
sui client switch --address YOUR_ADDRESS

# Get testnet tokens
sui client faucet

# Check your balance
sui client balance
```

### 3. Install Project Dependencies

```bash
# In the project root
npm install

# Install TypeScript globally (optional)
npm install -g typescript ts-node
```

## Configuration

### 1. Environment Variables

Create a `.env` file in the project root:

```env
# Sui Network Configuration
SUI_NETWORK=testnet
SUI_RPC_URL=https://fullnode.testnet.sui.io:443

# Walrus Configuration
WALRUS_NETWORK=testnet
WALRUS_CONFIG_PATH=./config/testnet.yaml

# Your wallet configuration
SUI_PRIVATE_KEY=your_private_key_here
SUI_ADDRESS=your_address_here

# Optional: Custom storage node endpoints
WALRUS_PUBLISHER_URL=https://publisher.testnet.walrus.space
WALRUS_AGGREGATOR_URL=https://aggregator.testnet.walrus.space
```

### 2. Network Configuration

The `config/testnet.yaml` file contains network-specific settings:

```yaml
# Testnet configuration
network: testnet
sui_rpc_url: https://fullnode.testnet.sui.io:443
walrus_system_object: "0x98ebc47370603fe81d9e15491b2f1443d619d1dab720d586e429ed233e1255c1"
walrus_staking_pool: "0x20266a17b4f1a216727f3eef5772f8d486a9e3b5e319af80a5b75809c035561d"

# Storage node endpoints
publisher_url: https://publisher.testnet.walrus.space
aggregator_url: https://aggregator.testnet.walrus.space

# Default storage parameters
default_epochs: 3
default_deletable: false
```

## First Steps

### 1. Verify Installation

```bash
# Check Sui CLI
sui --version

# Check Node.js
node --version
npm --version

# Check TypeScript (if installed)
tsc --version
```

### 2. Test Sui Connection

```bash
# Check network connection
sui client active-address
sui client balance

# Test transaction
sui client gas
```

### 3. Test Walrus Connection

```bash
# Using our test script
./scripts/test-connection.sh

# Or manually with curl
curl -X GET https://publisher.testnet.walrus.space/v1/status
```

## Your First Blob

### Using CLI

```bash
# Navigate to CLI examples
cd examples/cli

# Store a simple text file
echo "Hello Walrus!" > hello.txt
sui client call --package WALRUS_PACKAGE_ID --module blob --function store_blob --args hello.txt --gas-budget 1000000

# Or use the helper script
./store-blob.sh hello.txt
```

### Using TypeScript SDK

```bash
# Navigate to TypeScript examples
cd examples/typescript

# Install dependencies
npm install

# Run the basic example
npm run basic-example

# Or run manually
npx ts-node basic-store-retrieve.ts
```

Create a simple TypeScript example:

```typescript
// examples/typescript/basic-store-retrieve.ts
import { getFullnodeUrl, SuiClient } from '@mysten/sui/client';
import { WalrusClient } from '@mysten/walrus';
import { Ed25519Keypair } from '@mysten/sui/keypairs/ed25519';

async function main() {
  // Initialize Sui client
  const suiClient = new SuiClient({
    url: getFullnodeUrl('testnet'),
  });

  // Initialize Walrus client
  const walrusClient = new WalrusClient({
    network: 'testnet',
    suiClient,
  });

  // Create a keypair (use your own private key)
  const keypair = Ed25519Keypair.fromSecretKey(
    new Uint8Array(/* your private key bytes */)
  );

  try {
    // Store a blob
    const data = new TextEncoder().encode('Hello from Walrus!');
    
    console.log('Storing blob...');
    const result = await walrusClient.writeBlob({
      blob: data,
      deletable: false,
      epochs: 3,
      signer: keypair,
    });

    console.log('Blob stored successfully!');
    console.log('Blob ID:', result.blobId);

    // Retrieve the blob
    console.log('Retrieving blob...');
    const retrievedData = await walrusClient.readBlob({
      blobId: result.blobId,
    });

    console.log('Retrieved data:', new TextDecoder().decode(retrievedData));
    
  } catch (error) {
    console.error('Error:', error);
  }
}

main().catch(console.error);
```

### Using Python HTTP API

```bash
# Navigate to Python examples
cd examples/python

# Install dependencies
pip install -r requirements.txt

# Run the basic example
python basic_example.py
```

## Understanding Costs

### Storage Costs

Walrus uses a unique pricing model:

1. **WAL Tokens**: Used for storage payments
2. **SUI Tokens**: Used for transaction fees
3. **Epochs**: Storage duration (1 epoch ≈ 24 hours)
4. **Size-based**: Cost scales with blob size

### Estimating Costs

```bash
# Check current storage prices
curl -X GET https://publisher.testnet.walrus.space/v1/pricing

# Estimate cost for a blob
# Cost = base_fee + (size_in_bytes * per_byte_fee * epochs)
```

## Next Steps

1. **Explore Examples**: Check out the `/examples` directory for various use cases
2. **Read Concepts**: Understand the architecture in `docs/concepts.md`
3. **Build Something**: Try creating your own application
4. **Join Community**: Connect with other developers

## Common Issues

### Issue: "Insufficient gas"
**Solution**: Ensure you have enough SUI tokens and increase gas budget

### Issue: "Blob not found"
**Solution**: Check if the blob ID is correct and the storage period hasn't expired

### Issue: "Network timeout"
**Solution**: Check your internet connection and try different storage nodes

For more troubleshooting, see `docs/troubleshooting.md`.

## Resources

- [Walrus Documentation](https://docs.walrus.site/)
- [Sui Documentation](https://docs.sui.io/)
- [TypeScript SDK Reference](https://sdk.mystenlabs.com/walrus)
- [Community Discord](https://discord.gg/sui)

Ready to dive deeper? Continue with the [Core Concepts](./concepts.md) guide!