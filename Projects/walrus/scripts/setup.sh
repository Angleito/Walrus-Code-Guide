#!/bin/bash

# Walrus Learning Repository Setup Script
# This script sets up the development environment for Walrus blockchain storage

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color $BLUE "🌊 =================================="
    print_color $BLUE "   Walrus Learning Repository Setup"
    print_color $BLUE "=================================="
    echo ""
}

print_step() {
    print_color $YELLOW "📋 $1"
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_error() {
    print_color $RED "❌ $1"
}

print_info() {
    print_color $BLUE "ℹ️  $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Node.js dependencies
setup_nodejs() {
    print_step "Setting up Node.js dependencies..."
    
    if ! command_exists node; then
        print_error "Node.js is not installed. Please install Node.js 18+ first."
        print_info "Visit: https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node --version)
    print_success "Node.js version: $NODE_VERSION"
    
    # Install root dependencies
    print_step "Installing root dependencies..."
    npm install
    
    # Install TypeScript example dependencies
    print_step "Installing TypeScript example dependencies..."
    cd examples/typescript
    npm install
    cd ../..
    
    print_success "Node.js setup complete!"
}

# Install Python dependencies
setup_python() {
    print_step "Setting up Python dependencies..."
    
    if ! command_exists python3; then
        print_error "Python 3 is not installed. Please install Python 3.8+ first."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version)
    print_success "Python version: $PYTHON_VERSION"
    
    # Create virtual environment for Python examples
    print_step "Creating Python virtual environment..."
    cd examples/python
    python3 -m venv venv
    source venv/bin/activate
    
    # Install requirements
    print_step "Installing Python requirements..."
    pip install -r requirements.txt
    
    cd ../..
    print_success "Python setup complete!"
}

# Check Sui CLI installation
check_sui_cli() {
    print_step "Checking Sui CLI installation..."
    
    if ! command_exists sui; then
        print_error "Sui CLI is not installed."
        print_info "Install with: cargo install --locked --git https://github.com/MystenLabs/sui.git --branch testnet sui"
        print_info "Or download from: https://github.com/MystenLabs/sui/releases"
        return 1
    fi
    
    SUI_VERSION=$(sui --version)
    print_success "Sui CLI version: $SUI_VERSION"
    return 0
}

# Setup Sui wallet
setup_sui_wallet() {
    print_step "Setting up Sui wallet..."
    
    if ! check_sui_cli; then
        print_error "Sui CLI not available. Skipping wallet setup."
        return 1
    fi
    
    # Check if wallet exists
    if sui client active-address >/dev/null 2>&1; then
        ACTIVE_ADDRESS=$(sui client active-address)
        print_success "Active wallet address: $ACTIVE_ADDRESS"
        
        # Check balance
        print_step "Checking wallet balance..."
        sui client balance
        
        print_info "If you need testnet tokens, run: sui client faucet"
    else
        print_info "No active wallet found. Creating a new wallet..."
        print_info "Run: sui client new-address ed25519"
        print_info "Then: sui client faucet"
    fi
}

# Create environment file
create_env_file() {
    print_step "Creating environment configuration..."
    
    if [ ! -f .env ]; then
        print_step "Creating .env file..."
        cat > .env << EOF
# Sui Network Configuration
SUI_NETWORK=testnet
SUI_RPC_URL=https://fullnode.testnet.sui.io:443

# Walrus Configuration
WALRUS_NETWORK=testnet
WALRUS_CONFIG_PATH=./config/testnet.yaml

# Your wallet configuration (replace with your actual values)
# SUI_PRIVATE_KEY=your_private_key_here
# SUI_ADDRESS=your_address_here

# Optional: Custom storage node endpoints
WALRUS_PUBLISHER_URL=https://publisher.testnet.walrus.space
WALRUS_AGGREGATOR_URL=https://aggregator.testnet.walrus.space
EOF
        print_success ".env file created! Please edit it with your wallet information."
    else
        print_success ".env file already exists."
    fi
}

# Create test data
create_test_data() {
    print_step "Creating test data..."
    
    mkdir -p test-data
    
    # Create sample text file
    cat > test-data/sample.txt << EOF
Hello from Walrus!
This is a sample text file for testing blob storage.
Created on: $(date)
EOF
    
    # Create sample JSON file
    cat > test-data/sample.json << EOF
{
  "message": "Hello from Walrus!",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "author": "Walrus Learning Repository",
  "data": {
    "numbers": [1, 2, 3, 4, 5],
    "nested": {
      "value": "This is nested data",
      "active": true
    }
  }
}
EOF
    
    print_success "Test data created in test-data/ directory"
}

# Main setup function
main() {
    print_header
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ]; then
        print_error "Please run this script from the project root directory."
        exit 1
    fi
    
    print_info "Setting up Walrus learning environment..."
    
    # Setup Node.js
    setup_nodejs
    
    # Setup Python
    setup_python
    
    # Setup Sui wallet
    setup_sui_wallet
    
    # Create environment file
    create_env_file
    
    # Create test data
    create_test_data
    
    print_color $GREEN "\n🎉 Setup complete!"
    print_info "Next steps:"
    print_info "1. Edit .env file with your wallet information"
    print_info "2. Run: sui client faucet (if you need testnet tokens)"
    print_info "3. Try: cd examples/typescript && npm run basic-example"
    print_info "4. Or: cd examples/python && python3 basic_example.py"
    print_info "5. Read the documentation in docs/ directory"
    
    print_color $BLUE "\n📚 Resources:"
    print_info "• Documentation: https://docs.walrus.site/"
    print_info "• Sui Docs: https://docs.sui.io/"
    print_info "• TypeScript SDK: https://sdk.mystenlabs.com/walrus"
    print_info "• Community: https://discord.gg/sui"
    
    echo ""
    print_color $GREEN "Happy coding with Walrus! 🌊"
}

# Run main function
main 